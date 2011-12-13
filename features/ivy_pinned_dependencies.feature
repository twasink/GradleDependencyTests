Feature: Pinned Dependency Resolution

  Pinned dependencies are dependencies bound to an individual version number.
  They indicate a required version, as opposed to an unbound version number,
  which is more of a strong preference.

  Ivy and Maven have different syntax for doing these kind of version numbers,
  but for pinned versions they happen to be the same - [version]. This version
  explores what happens when the repository is backed by ivy

  Background:
    Given that an Ivy repository is being used
    And "Samwise" "1.0" exists
    And "Samwise" "1.1" exists


  Scenario: Ivy pinned dependencies with no conflict
    Given "Frodo" "1.0" depends on "Samwise" "[1.0]"
    Then the ivy build for "Frodo" "1.0" will include "Samwise" "1.0"
    And the gradle build for "Frodo" "1.0" will include "Samwise" "1.0"

  Scenario: Ivy pinned dependency overrides normal preference in a transitive chain
    Given "Frodo" "1.0" depends on "Samwise" "1.1"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    And "Gandalf" "1.0" depends on "Samwise" "[1.0]"
    Then the ivy build for "Gandalf" "1.0" will include "Samwise" "1.0"
    And the gradle build for "Gandalf" "1.0" will include "Samwise" "1.0"

  Scenario: Ivy pinned dependency in chain bubbles upwards to top
    Given "Frodo" "1.0" depends on "Samwise" "[1.0]"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    And "Gandalf" "1.0" depends on "Samwise" "1.1"
    Then the ivy build for "Gandalf" "1.0" will include "Samwise" "1.0"
    And the gradle build for "Gandalf" "1.0" will include "Samwise" "1.0"

  Scenario: Ivy pinned dependency in diamond structure resolves between peers
    Given "Frodo" "1.0" depends on "Samwise" "[1.0]"
    And "Aragon" "1.0" depends on "Samwise" "1.1"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    And "Gandalf" "1.0" depends on "Aragon" "1.0"
    Then the ivy build for "Gandalf" "1.0" will include "Samwise" "1.0"
    And the gradle build for "Gandalf" "1.0" will include "Samwise" "1.0"

  Scenario: Ivy pinned dependency in nested diamond structure resolves between peers
    Given "Frodo" "1.0" depends on "Samwise" "[1.0]"
    And "Aragon" "1.0" depends on "Samwise" "1.1"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    And "Gandalf" "1.0" depends on "Aragon" "1.0"
    And "Elrond" "1.0" depends on "Gandalf" "1.0"
    Then the ivy build for "Elrond" "1.0" will include "Samwise" "1.0"
    And the gradle build for "Elrond" "1.0" will include "Samwise" "1.0"
