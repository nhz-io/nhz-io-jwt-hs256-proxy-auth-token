fs              = require 'fs'

coffeescript    = require 'coffeescript'
coffeelint      = require 'coffeelint'

lint            = require 'coffeelint'
lintConfig      = require './coffeelint.json'
LintReporter    = require 'coffeelint/lib/reporters/default'

file            = 'README.litcoffee'


task 'lint', 'coffeelint', ->
    fs.readFile file, 'utf8', (err, source) ->
        throw err if err

        errorReport = new coffeelint.getErrorReport()

        errorReport.lint file, source, lintConfig, true

        reporter = new LintReporter errorReport, { colorize: process.stdout.isTTY }

        reporter.publish()

        process.on 'exit', -> process.exit errorReport.getExitCode()


task 'build', 'build index.js', ->
    fs.readFile file, 'utf8', (err, source) ->
        throw err if err

        # Strip test and badges
        source = source.split('## Test').shift().replace /^!?\[.+$/gmi, ''

        res = coffeescript.compile source, {
            bare: true,
            header: false,
            literate: true,
            sourceMap: true,
            filename: 'README.litcoffee'
        }

        fs.writeFile 'index.js', res.js, 'utf8', (err) ->
            throw err if err

            fs.writeFile 'index.js.map', res.v3SourceMap, 'utf8', (err) ->
                throw err if err
