# Contributing to Kerberus

Welcome, and thank you for considering contributing to Kerberus. We encourage
you to help out by raising issues, improving documentation, fixing bugs, or
adding new features

If you're interested in contributing please start by reading this document. If
you have any questions at all, or don't know where to start, please reach out to
us on [Slack]. Please also take a look at our [code of conduct], which details
how contributors are expected to conduct themselves as part of the Kerberus
community.

## Establishing a Development Environment

TBD

## Contributing Code

To contribute bug fixes or features to Kerberus:

1. Communicate your intent.
1. Make your changes.
1. Test your changes.
1. Update documentation and examples.
1. Open a Pull Request (PR).

Communicating your intent lets the Kerberus maintainers know that you intend
to contribute, and how. This sets you up for success - you can avoid duplicating
an effort that may already be underway, adding a feature that may be rejected,
or heading down a path that you would be steered away from at review time. The
best way to communicate your intent is via a detailed GitHub issue. Take a look
first to see if there's already an issue relating to the thing you'd like to
contribute. If there isn't, please raise a new one! Let us know what you'd like
to work on, and why. The Kerberus maintainers can't always triage new issues
immediately, but we encourage you to bring them to our attention via [Slack].

> NOTE: new features can only being merged during the active development period
> of a Kerberus release cycle. If implementation and review of a new feature
> cannot be accomplished prior to feature freeze, it may be bumped to the next
> release cycle. See the [Kerberus release cycle] documentation for more
> information.

Be sure to practice [good git commit hygiene] as you make your changes. All but
the smallest changes should be broken up into a few commits that tell a story.
Use your git commits to provide context for the folks who will review PR, and
the folks who will be spelunking the codebase in the months and years to come.
Ensure each of your commits is signed-off in compliance with the [Developer
Certificate of Origin] by using `git commit -s`. The Kerberus highly values
readable, idiomatic Go code. Familiarise yourself with common [code review
comments] that are left on Go PRs - try to preempt any that your reviewers would
otherwise leave. Run `make reviewable` to lint your change.

All Kerberus code must be covered by tests. Note that unlike many Kubernetes
projects Kerberus does not use gingko tests and will request changes to any PR
that uses gingko or any third party testing library, per the common Go [test
review comments]. Kerberus encourages the use of table driven unit tests. Note
that when opening a PR your reviewer will expect you to detail how you've tested
your work. For all but the smallest changes some manual testing is encouraged in
addition to unit tests.

All Kerberus documentation and examples are under revision control; see the
[docs] and [examples] directories of this repository. Any change that introduces
new behaviour or changes existing behaviour must include updates to any relevant
documentation and examples. Please keep documentation and example changes in
distinct commits.

Once your change is written, tested, and documented the final step is to have it
reviewed! You'll be presented with a template and a small checklist when you
open a PR. Please read the template and fill out the checklist. Please make all 
PR request changes in subsequent commits. This allows your reviewers to see what
has changed as you address their comments. Be mindful
of  your commit history as you do this - avoid commit messages like "Address
review feedback" if possible. If doing so is difficult a good alternative is to
rewrite your commit history to clean them up after your PR is approved but
before it is merged.

In summary, please:

* Discuss your change in a GitHub issue before you start.
* Use your Git commit messages to communicate your intent to your reviewers.
* Sign-off on all Git commits by running `git commit -s`
* Add or update tests for all changes.
* Preempt common [code review comments] and [test review comments].
* Update all relevant documentation and examples.
* Don't force push to address review feedback. Your commits should tell a story.
* If necessary, tidy up your git commit history once your PR is approved.

Thank you for reading through our contributing guide! We appreciate you taking
the time to ensure your contributions are high quality and easy for our
community to review and accept. Please don't hesitate to [reach out to
us][Slack] if you have any questions about contributing!

[Slack]: https://kerberus.slack.com/channels/dev
[code of conduct]: https://github.com/cncf/foundation/blob/master/code-of-conduct.md
[Kerberus release cycle]: docs/reference/release-cycle.md
[good git commit hygiene]: https://www.futurelearn.com/info/blog/telling-stories-with-your-git-history
[Developer Certificate of Origin]: https://github.com/apps/dco
[code review comments]: https://github.com/golang/go/wiki/CodeReviewComments
[test review comments]: https://github.com/golang/go/wiki/TestComments
[docs]: docs/
[examples]: examples/
