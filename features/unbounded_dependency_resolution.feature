Feature: Unbounded Dependency Resolution

  Scenario: Single choice, Simple resolution
    Given "Samwise" "1.0" exists
    And "Frodo" "1.0" depends on "Samwise" "1.0"
    Then the build for "Frodo" "1.0" will include "Samwise" "1.0"

  @wip
  Scenario: Multiple choices, simple resolution of older dependency
    Given "Samwise" "1.0" exists
    And "Samwise" "1.1" exists
    And "Frodo" "1.0" depends on "Samwise" "1.0"
    Then the build for "Frodo" "1.0" will include "Samwise" "1.0"

  @wip
  Scenario: Multiple choices, simple resolution of newer dependency
    Given "Samwise" "1.0" exists
    And "Samwise" "1.1" exists
    And "Frodo" "1.0" depends on "Samwise" "1.0"
    Then the build for "Frodo" "1.0" will include "Samwise" "1.1"

  @wip
  Scenario: Transitive dependencies, single chain
    Given "Samwise" "1.0" exists
    And "Frodo" "1.0" depends on "Samwise" "1.0"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    Then the build for "Gandalf" "1.0" will include "Samwise" "1.0"

  @wip
  Scenario: Transitive dependencies, older in top module
    Given "Samwise" "1.0" exists
    And "Samwise" "1.1" exists
    And "Frodo" "1.0" depends on "Samwise" "1.1"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    And "Gandalf" "1.0" depends on "Samwise" "1.0"
    Then the build for "Gandalf" "1.0" will include "Samwise" "1.1"

  @wip
  Scenario: Transitive dependencies, newer in top module
    Given "Samwise" "1.0" exists
    And "Samwise" "1.1" exists
    And "Frodo" "1.0" depends on "Samwise" "1.0"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    And "Gandalf" "1.0" depends on "Samwise" "1.1"
    Then the build for "Gandalf" "1.0" will include "Samwise" "1.1"

  @wip
  Scenario: Transitive dependencies, older in top module
    Given "Samwise" "1.0" exists
    And "Samwise" "1.1" exists
    And "Frodo" "1.0" depends on "Samwise" "1.1"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    And "Gandalf" "1.0" depends on "Samwise" "1.0"
    Then the build for "Gandalf" "1.0" will include "Samwise" "1.1"

  @wip
  Scenario: Transitive dependencies, diamond structure, no conflicts
    Given "Samwise" "1.0" exists
    And "Frodo" "1.0" depends on "Samwise" "1.0"
    And "Aragon" "1.0" depends on "Samwise" "1.0"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    And "Gandalf" "1.0" depends on "Aragon" "1.0"
    Then the build for "Gandalf" "1.0" will include "Samwise" "1.0"

  @wip
  Scenario: Transitive dependencies, diamond structure, mismatched versions
    Given "Samwise" "1.0" exists
    And "Frodo" "1.0" depends on "Samwise" "1.0"
    And "Aragon" "1.0" depends on "Samwise" "1.1"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    And "Gandalf" "1.0" depends on "Aragon" "1.0"
    Then the build for "Gandalf" "1.0" will include "Samwise" "1.1"

  @wip
  Scenario: Transitive dependencies, diamond structure, older version at top
    Given "Samwise" "1.0" exists
    And "Frodo" "1.0" depends on "Samwise" "1.0"
    And "Aragon" "1.0" depends on "Samwise" "1.1"
    And "Gandalf" "1.0" depends on "Samwise" "1.0"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    And "Gandalf" "1.0" depends on "Aragon" "1.0"
    Then the build for "Gandalf" "1.0" will include "Samwise" "1.1"

  @wip
  Scenario: Transitive dependencies, diamond structure, newer version at top
    Given "Samwise" "1.0" exists
    And "Frodo" "1.0" depends on "Samwise" "1.0"
    And "Aragon" "1.0" depends on "Samwise" "1.0"
    And "Gandalf" "1.0" depends on "Samwise" "1.1"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    And "Gandalf" "1.0" depends on "Aragon" "1.0"
    Then the build for "Gandalf" "1.0" will include "Samwise" "1.1"