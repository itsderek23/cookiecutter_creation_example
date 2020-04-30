# CD4ML CookieCutter Data Science Example

This demonstrates how to use the Booklet-forked Cookiecutter Data Science project to convert an unstructured project into a structured one.

## Prerequisites

* A GitHub account + personal access token: https://github.com/settings/tokens
  * Scopes: delete_repo, repo
  * Set an env variable w/your token (GITHUB_TOKEN=[YOUR TOKEN])
* A Kaggle account and stored API credentials
* An AWS account and stored your credentials
* Set the environment variables listed in `.envrc.example`

## Execution

The shell script `setup.sh` creates a Cookiecutter project in the `disaster_tweets` directory, copies files to the correct places, setups dvc stages, downloads the dataset, trains the model, creates a GitHub repo, etc.

To execute:

```
./setup.sh
```
