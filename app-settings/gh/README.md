# gh

Extras for the [GitHub CLI](https://cli.github.com/).

## gh dependabot

[gh-dependabot](gh-dependabot) lists open Dependabot PRs for the active `gh auth` account.

```bash
gh dependabot          # your own non-archived repos
gh dependabot cdcent   # repos in an org that you've committed to
```

Use `gh auth switch` to change accounts, or check another account without switching:

```bash
GH_TOKEN=$(gh auth token --user fartbagxp) gh dependabot
```

It lists each repo's open PRs and filters by author instead of using GitHub search. Search can't see some orgs (SAML/enterprise policies) and returns nothing without an error.

### Install

```bash
cp gh-dependabot ~/.local/bin/
chmod +x ~/.local/bin/gh-dependabot
gh alias set --shell dependabot 'gh-dependabot "$@"'
```
