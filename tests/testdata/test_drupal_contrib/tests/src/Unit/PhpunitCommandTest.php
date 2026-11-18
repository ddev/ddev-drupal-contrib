<?php

namespace Drupal\Tests\test_drupal_contrib\Unit;

use PHPUnit\Framework\TestCase;

/**
 * Test that the ddev phpunit command can run.
 */
class PhpunitCommandTest extends TestCase {

  /**
   * Test that the test runs.
   */
  public function testRun(): void {
    $this->assertTrue(TRUE);
  }

}
