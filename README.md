DDEV integration for Drupal contrib projects. This project reuses the code and approach from the [Drupal Association's Gitlab CI workflow](https://git.drupalcode.org/project/gitlab_templates/). As a general philosophy, Your contributed module is the center of the universe. It lives at the root of your codebase.

Workflow
============

A typical workflow for using this project.

- Git clone your project from drupal.org. 
- [Add DDEV to your contrib project](https://ddev.readthedocs.io/en/latest/users/project/). 
- Run `dev get ddev/ddev-drupal-gitlabci`. From now on, each time you start DDEV your module gets symlinked into the web/modules/custom directory so that Drupal can find it (see install.yaml/post_install_actions).
- Run `ddev composer-ci`. This edits composer.json so that Drupal core becomes a dev dependency.
- Run `ddev composer install` or `composer install`
- Optional: [Install Chrome service for FunctionalJavascript and Nightwatch tests](https://github.com/ddev/ddev-selenium-standalone-chrome).
- Run tests, appending options and arguments as needed. 
  - `ddev phpunit`
  - `ddev phpcs`
  - `ddev nightwatch`

Misc
=======
- Optional. Check in the composer.json after `ddev composer-ci` runs.
- To sign up for Gitlab CI, see https://www.drupal.org/project/infrastructure/issues/3261803.

**Contributed and maintained by [@weitzman](https://github.com/weitzman)**
