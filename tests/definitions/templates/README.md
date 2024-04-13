# test definitions

Each test definition is a shell script that is sourced by the main test script.
The test definition should not exit the shell.
Each test definition should define define a name variable used to identify the test.
Each test should use the `pass` alias to run a command that is expected to succeed.
Each test should use the `fail` alias to run a command that is expected to fail.
All other variables except `name` should be local.
Multiple test definitions can be defined in a single file.
