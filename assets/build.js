const esbuild = require('esbuild');
const postcss = require('postcss');
const autoprefixer = require('autoprefixer');
const tailwindcss = require('tailwindcss');
const fs = require('fs');

const args = process.argv.slice(2);
const watch = args.includes('--watch');
const deploy = args.includes('--deploy');

const loader = {
  '.js': 'jsx',
  '.ts': 'tsx',
};

// Define esbuild options
const options = {
  entryPoints: ['js/app.js'],
  bundle: true,
  target: 'es2017',
  outdir: '../priv/static/assets',
  external: ['*.css', '*.png', '*.jpg', '*.jpeg', '*.gif', '*.svg'],
  loader: loader,
  logLevel: 'info',
};

// Create the CSS processing function
async function processCss() {
  const css = fs.readFileSync('css/app.css', 'utf8');
  const result = await postcss([
    tailwindcss('./tailwind.config.js'),
    autoprefixer,
  ]).process(css, { from: 'css/app.css', to: '../priv/static/assets/app.css' });
  
  fs.mkdirSync('../priv/static/assets', { recursive: true });
  fs.writeFileSync('../priv/static/assets/app.css', result.css);
}

// Process CSS initially
processCss();

if (watch) {
  // Watch JS
  esbuild.context({
    ...options,
    watch: {
      onRebuild(error, result) {
        if (error) console.error('esbuild failed:', error);
        else console.log('esbuild: rebuilt JS successfully');
        // Rebuild CSS on JS changes
        processCss().catch(error => console.error('CSS processing failed:', error));
      },
    },
  }).then(context => {
    console.log('Watching JS and CSS files...');
  });
  
  // Watch CSS files separately
  fs.watch('css', { recursive: true }, (eventType, filename) => {
    console.log(`CSS file changed: ${filename}`);
    processCss().catch(error => console.error('CSS processing failed:', error));
  });
} else if (deploy) {
  // Build for production
  esbuild.build({
    ...options,
    minify: true,
  }).catch(() => process.exit(1));
} else {
  // One-time build
  esbuild.build({
    entryPoints: ['js/app.js'],
    bundle: true,
    outfile: 'dist/app.js',
    external: ['phoenix_html', 'phoenix', 'phoenix_live_view'], // Mark as external
  }).catch(() => process.exit(1));
}
