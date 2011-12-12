Feature: Forced Dependency Resolution

  Forced dependencies are a new feature to Gradle (1.0-m7). They allow a build
  author to require a particular version of a dependency (transitive or otherwise)
  to be used - this helps to resolve conflicts between dependencies.

  Forced dependencies do not appear to be transitive - they are only used for the
  build they are defined in.

  Scenario: Forced dependency overrides normal preference in a transitive chain
    Given "Samwise" "1.0" exists
    And "Samwise" "1.1" exists
    And "Frodo" "1.0" depends on "Samwise" "1.1"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    And "Gandalf" "1.0" forcibly relies on "Samwise" "1.0"
    And the gradle build for "Gandalf" "1.0" will include "Samwise" "1.0"


  Scenario: Forced dependency in diamond structure resolves between peers
    Given "Samwise" "1.0" exists
    And "Samwise" "1.1" exists
    And "Frodo" "1.0" depends on "Samwise" "1.0"
    And "Aragon" "1.0" depends on "Samwise" "1.1"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    And "Gandalf" "1.0" depends on "Aragon" "1.0"
    And "Gandalf" "1.0" forcibly relies on "Samwise" "1.0"
    And the gradle build for "Gandalf" "1.0" will include "Samwise" "1.0"

  Scenario: Forced dependency in nested diamond structure resolves between peers
    Given "Samwise" "1.0" exists
    And "Samwise" "1.1" exists
    And "Frodo" "1.0" depends on "Samwise" "1.0"
    And "Aragon" "1.0" depends on "Samwise" "1.1"
    And "Gandalf" "1.0" depends on "Frodo" "1.0"
    And "Gandalf" "1.0" depends on "Aragon" "1.0"
    And "Gandalf" "1.0" forcibly relies on "Samwise" "1.0"
    And "Elrond" "1.0" depends on "Gandalf" "1.0"
    And the gradle build for "Elrond" "1.0" will include "Samwise" "1.0"
