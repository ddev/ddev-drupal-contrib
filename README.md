DDEV integration for developing Drupal contrib projects. This project reuses the code and approach from the [Drupal Association's Gitlab CI workflow](https://git.drupalcode.org/project/gitlab_templates/). It should work for any contrib project, including those that havent [opted into Gitlab CI](https://www.drupal.org/project/infrastructure/issues/3261803). One advantage of that is that failures in CI are more likely to be reproducible locally when using this integration.

As a general philosophy, Your contributed module is the center of the universe. It lives at the root of your codebase.

Usage
============
- Git clone your project from drupal.org. 
- [Add DDEV to your contrib project](https://ddev.readthedocs.io/en/latest/users/project/) if not already added. 
- Run `ddev get weitzman/ddev-drupal-gitlabci`. From now on, each time you start DDEV, your module gets symlinked into the `web/modules/custom` directory so that Drupal can find it (see the [expand-composer-json](https://github.com/weitzman/ddev-drupal-gitlabci/blob/main/commands/web/expand-composer-json)) command.
- Run `ddev expand-composer-json`. This edits composer.json so that `drupal/core-recommended` becomes a dev dependency.
- Run `ddev composer install` or `composer install`
- Run tests, appending options and arguments as needed. 
  - `ddev phpunit`
  - `ddev nightwatch`
  - `ddev phpcs`

Misc
=======
- Optional: [Install Chrome service for FunctionalJavascript and Nightwatch tests](https://github.com/ddev/ddev-selenium-standalone-chrome).
- Optional. Commit the changes .ddev after this plugin installs. This saves other users from having to run this command. Rerun the `ddev get` in order to update the commands from this project.
- This project reads your `project_type` from DDEV and fetches adds the corresponding version of `drupal/core-recommended` to composer.json. if you are doing something non-standard with project_type, just don't use `ddev expand-composer-json` command.
- If you add/remove a root file or directory, re-symlink root files via EITHER of these methods 
  - `ddev restart`
  - `ddev symlink-project`
- To sign up for Gitlab CI, see https://www.drupal.org/project/infrastructure/issues/3261803.

**Contributed and maintained by [@weitzman](https://github.com/weitzman)**
