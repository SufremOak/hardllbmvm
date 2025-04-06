import { parseArgs } from 'util';
import fs from 'fs';
import path from 'path';

import { fileURLToPath } from 'url';
import { createRequire } from 'module';
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const require = createRequire(import.meta.url);
const { version } = require('./packages/package.json');

const { args } = parseArgs({
  options: {
    version: {
      type: 'boolean',
      short: 'v',
      help: 'Show version number',
    },
    help: {
      type: 'boolean',
      short: 'h',
      help: 'Show help message',
    },
  },
});
const { version: showVersion, help } = args;
const helpText = `
Usage: node main.js [options]
Options:
  -v, --version  Show version number
  -h, --help     Show help message
`

if (showVersion) {
  console.log(`Version: ${version}`);
  process.exit(0);
}
if (help) {
  console.log(helpText);
  process.exit(0);
}
const { execSync } = require('child_process');
const { argv } = process;
const command = argv[2];
const args = argv.slice(3);
const packageName = argv[2];
const packagePath = path.join(__dirname, 'packages', packageName);

if (!fs.existsSync(packagePath)) {
  console.error(`Package "${packageName}" does not exist.`);
  process.exit(1);
}
const packageJsonPath = path.join(packagePath, 'package.json');
