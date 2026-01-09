# Contributing to Minecraft Server Setup

First off, thanks for taking the time to contribute! 🎉

The following is a set of guidelines for contributing to this Minecraft Server project. These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

## 📋 Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [How Can I Contribute?](#how-can-i-contribute)
   - [Reporting Bugs](#reporting-bugs)
   - [Suggesting Enhancements](#suggesting-enhancements)
   - [Pull Requests](#pull-requests)
3. [Development Setup](#development-setup)
4. [Styleguides](#styleguides)
   - [Bash Scripts](#bash-scripts)
   - [Docker](#docker)

## 🤝 Code of Conduct

This project and everyone participating in it is governed by a Code of Conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainers.

## 🚀 How Can I Contribute?

### Reporting Bugs

This section guides you through submitting a bug report. Following these guidelines helps maintainers and the community understand your report, reproduce the behavior, and find related reports.

- **Use a clear and descriptive title** for the issue to identify the problem.
- **Describe the exact steps to reproduce the problem** in as many details as possible.
- **Provide specific examples** to demonstrate the steps.
- **Describe the behavior you observed** after following the steps and point out what exactly is the problem with that behavior.
- **Explain which behavior you expected to see** instead and why.
- **Include logs** if possible (sanitize them first!). You can get logs using `./scripts/logs.sh`.

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion, including completely new features and minor improvements to existing functionality.

- **Use a clear and descriptive title** for the issue to identify the suggestion.
- **Provide a step-by-step description of the suggested enhancement** in as many details as possible.
- **Explain why this enhancement would be useful** to most users.

### Pull Requests

The process described here has several goals:

- Maintain the quality of the scripts and configuration.
- Fix problems that are important to users.
- Engage the community in working toward the best possible server setup.

1.  Fork the repo and create your branch from `main`.
2.  If you've added code that should be tested, add tests (or describe how to test it).
3.  If you've changed APIs or script arguments, update the documentation.
4.  Ensure the test suite passes (if applicable) or manually verify your changes.
5.  Make sure your code follows the existing style.
6.  Issue that pull request!

## 🛠️ Development Setup

Refer to the README.md for detailed installation instructions.

1.  Clone the repository.
2.  Run `./scripts/setup.sh` to initialize the environment.
3.  Test your changes locally using the provided scripts.

## 📝 Styleguides

### Bash Scripts

-   **Shebang**: Always start with `#!/bin/bash`.
-   **Permissions**: Ensure scripts are executable (`chmod +x`).
-   **Comments**: Comment your code, especially complex logic. Use the header block found in existing scripts.
-   **Variables**: Use uppercase for global constants/config, lowercase for local variables.
-   **Error Handling**: Check for command failures where appropriate.
-   **Output**: Use colors defined in the scripts (GREEN, YELLOW, RED, BLUE) to make output readable.

Example Header:
```bash
#!/bin/bash

##############################################################################
# SCRIPT NAME
#
# Purpose: Brief description
# Usage: ./scripts/script_name.sh
##############################################################################
```

### Docker

-   Keep `docker-compose.yml` clean and commented.
-   Use environment variables in `.env` for configurable values rather than hardcoding them in `docker-compose.yml`.