# frozen_string_literal: true

# Define composable `not_to change` matcher.
# cf. https://stackoverflow.com/a/34969429
#
# Example:
#   expect { project.update(title: "foo") }
#     .to change { project.title }
#     .and not_change { project.description }

RSpec::Matchers.define_negated_matcher :not_change, :change
