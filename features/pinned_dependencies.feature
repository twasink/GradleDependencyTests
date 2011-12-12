Feature: Pinned Dependency Resolution

  Pinned dependencies are dependencies bound to an individual version number.
  They indicate a required version, as opposed to an unbound version number,
  which is more of a strong preference.

  Ivy and Maven have different syntax for doing these kind of version numbers,
  but for pinned versions they happen to be the same - [version]


  Scenario: Pinned dependencies with no conflict
    Given "Samwise" "1.0" exists
    And "Frodo" "1.0" depends on "Samwise" "[1.0]"
    Then the maven build for "Frodo" "1.0" will include "Samwise" "1.0"
    And the gradle build for "Frodo" "1.0" will include "Samwise" "1.0"

  Scenario: Pinned dependency overrides normal preference in a transitive chain
    Given "Samwise" "1.0" exists
    And "Samwise" "1.1" exists
    And "Frodo" "1.0" depends on "Samwise" "1.1"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    And "Gandalf" "1.0" depends on "Samwise" "[1.0]"
    Then the maven build for "Gandalf" "1.0" will include "Samwise" "1.0"
    And the gradle build for "Gandalf" "1.0" will include "Samwise" "1.0"

  Scenario: Pinned dependency in chain bubbles upwards to top
    Given "Samwise" "1.0" exists
    And "Samwise" "1.1" exists
    And "Frodo" "1.0" depends on "Samwise" "[1.0]"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    And "Gandalf" "1.0" depends on "Samwise" "1.1"
    Then the maven build for "Gandalf" "1.0" will include "Samwise" "1.0"
    And the gradle build for "Gandalf" "1.0" will include "Samwise" "1.0"

  Scenario: Pinned dependency in diamond structure resolves between peers
    Given "Samwise" "1.0" exists
    And "Samwise" "1.1" exists
    And "Frodo" "1.0" depends on "Samwise" "[1.0]"
    And "Aragon" "1.0" depends on "Samwise" "1.1"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    And "Gandalf" "1.0" depends on "Aragon" "1.0"
    Then the maven build for "Gandalf" "1.0" will include "Samwise" "1.0"
    And the gradle build for "Gandalf" "1.0" will include "Samwise" "1.0"

  Scenario: Pinned dependency in nested diamond structure resolves between peers
    Given "Samwise" "1.0" exists
    And "Samwise" "1.1" exists
    And "Frodo" "1.0" depends on "Samwise" "[1.0]"
    And "Aragon" "1.0" depends on "Samwise" "1.1"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    And "Gandalf" "1.0" depends on "Aragon" "1.0"
    And "Elrond" "1.0" depends on "Gandalf" "1.0"
    Then the maven build for "Elrond" "1.0" will include "Samwise" "1.0"
    And the gradle build for "Elrond" "1.0" will include "Samwise" "1.0"
