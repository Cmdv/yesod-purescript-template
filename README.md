## Yesod Purescript
Haskell Yesdo RestAPI backend and Purescript Halogen frontend

RestAPI is based on [yesod-rest](https://github.com/psibi/yesod-rest)
The Halogen uses [purescript-halogen-template](https://github.com/vladciobanu/purescript-halogen-example)


## Postgres Setup
coming soon...


## Haskell Setup

1. If you haven't already, [install Stack](https://haskell-lang.org/get-started)
	* On POSIX systems, this is usually `curl -sSL https://get.haskellstack.org/ | sh`
2. Install the `yesod` command line tool: `stack install yesod-bin --install-ghc`
3. Build libraries: `stack build`

If you have trouble, refer to the [Yesod Quickstart guide](https://www.yesodweb.com/page/quickstart) for additional detail.

## Development

Start a development server with:

```
stack exec -- yesod devel
```

As your code changes, your site will be automatically be recompiled and redeployed to localhost.

## Tests

```
stack test --flag myapp:library-only --flag myapp:dev
```

(Because `yesod devel` passes the `library-only` and `dev` flags, matching those flags means you don't need to recompile between tests and development, and it disables optimization to speed up your test compile times).

## PureScript Setup
coming soon...
