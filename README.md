# sandtable

`sandtable` is a web application for broadcasting player orders for a game of Diplomacy recorded on Airtable.

## Table Structure

`sandtable` expects the following fields to be present in a game table.

* `Season` (Primary field, Single line text)
* `Austria-Hungary` (Long text)
* `Britain` (Long text)
* `France` (Long text)
* `Germany` (Long text)
* `Italy` (Long text)
* `Russia` (Long text)
* `Turkey` (Long text)
* `Public` (Checkbox)

## Endpoints

A single endpoint is exposed for reading individual game turns.

### Season

URL: `/game/:game-name/season/:season-name`

The `:game-name` is the name of the Airtable table, while the `:season-name` is the value of the `Season` field. The row fields that correspond to the game and season is returned by the endpoint.

Only rows that are marked as `Public` are available through the endpoint.

## Development

The server can be run using racket:

```shell
racket server.rkt
```

## Configuration

The server process is provided configuration through environment variables.

* `PORT` the port that the server should listen on.
* `AIRTABLE_API_KEY` the API key issued by Airtable to authorize access to the game tables.
* `AIRTABLE_BASE` the segment that appears after the `v0` in the API URL, e.g. `xxxxx` in `https://api.airtable.com/v0/xxxxx`.
