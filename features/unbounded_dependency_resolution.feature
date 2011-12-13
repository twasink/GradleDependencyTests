Feature: Unbounded Dependency Resolution

  This set of tests represents known working behaviour for Gradle. They cover typical
  scenarios for dependencies - both direct and indirect (transitive), but with no
  bounds on the dependencies. This is the standard behaviour for Gradle.

  Background:
    Given that a Maven repository is being used
    And "Samwise" "1.0" exists
    And "Samwise" "1.1" exists

  Scenario: Single choice, Simple resolution
    Given "Frodo" "1.0" depends on "Samwise" "1.0"
    Then the maven build for "Frodo" "1.0" will include "Samwise" "1.0"
    And the gradle build for "Frodo" "1.0" will include "Samwise" "1.0"

  Scenario: Multiple choices, simple resolution of older dependency
    Given "Frodo" "1.0" depends on "Samwise" "1.0"
    Then the gradle build for "Frodo" "1.0" will include "Samwise" "1.0"

  Scenario: Multiple choices, simple resolution of newer dependency
    Given "Frodo" "1.0" depends on "Samwise" "1.0"
    Then the gradle build for "Frodo" "1.0" will include "Samwise" "1.0"

  Scenario: Transitive dependencies, single chain
    Given "Frodo" "1.0" depends on "Samwise" "1.0"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    Then the gradle build for "Gandalf" "1.0" will include "Samwise" "1.0"

  Scenario: Transitive dependencies, older in top module
    Given "Frodo" "1.0" depends on "Samwise" "1.1"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    And "Gandalf" "1.0" depends on "Samwise" "1.0"
    # Frodo needs a newer version of Samwise than Gandalf, so we pick it up
    Then the gradle build for "Gandalf" "1.0" will include "Samwise" "1.1"

  Scenario: Transitive dependencies, newer in top module
    Given "Frodo" "1.0" depends on "Samwise" "1.0"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    And "Gandalf" "1.0" depends on "Samwise" "1.1"
    Then the gradle build for "Gandalf" "1.0" will include "Samwise" "1.1"

  Scenario: Transitive dependencies, older in top module
    Given "Frodo" "1.0" depends on "Samwise" "1.1"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    And "Gandalf" "1.0" depends on "Samwise" "1.0"
    Then the gradle build for "Gandalf" "1.0" will include "Samwise" "1.1"

  Scenario: Transitive dependencies, diamond structure, no conflicts
    Given "Frodo" "1.0" depends on "Samwise" "1.0"
    And "Aragon" "1.0" depends on "Samwise" "1.0"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    And "Gandalf" "1.0" depends on "Aragon" "1.0"
    Then the gradle build for "Gandalf" "1.0" will include "Samwise" "1.0"

  Scenario: Transitive dependencies, diamond structure, mismatched versions
    Given "Frodo" "1.0" depends on "Samwise" "1.0"
    And "Aragon" "1.0" depends on "Samwise" "1.1"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    And "Gandalf" "1.0" depends on "Aragon" "1.0"
    Then the gradle build for "Gandalf" "1.0" will include "Samwise" "1.1"

  Scenario: Transitive dependencies, diamond structure, older version at top
    Given "Frodo" "1.0" depends on "Samwise" "1.0"
    And "Aragon" "1.0" depends on "Samwise" "1.1"
    And "Gandalf" "1.0" depends on "Samwise" "1.0"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    And "Gandalf" "1.0" depends on "Aragon" "1.0"
    Then the gradle build for "Gandalf" "1.0" will include "Samwise" "1.1"

  Scenario: Transitive dependencies, diamond structure, newer version at top
    Given "Frodo" "1.0" depends on "Samwise" "1.0"
    And "Aragon" "1.0" depends on "Samwise" "1.0"
    And "Gandalf" "1.0" depends on "Samwise" "1.1"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    And "Gandalf" "1.0" depends on "Aragon" "1.0"
    Then the maven build for "Gandalf" "1.0" will include "Samwise" "1.1"
    And the gradle build for "Gandalf" "1.0" will include "Samwise" "1.1"
