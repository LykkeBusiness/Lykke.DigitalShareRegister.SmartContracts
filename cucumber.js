const feature = [
    '--require-module ts-node/register',
    '--require-module hardhat/register',
    '--require test/**/*.ts',
    `--format '@cucumber/pretty-formatter'`,
    '--publish-quiet',
  ].join(' ')

module.exports = { 
    default: feature
}