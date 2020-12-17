# Deck Maker

A Local web application that aims to act as a personal database of Magic the Gathering cards, collections and decks.

This is a personal project The project is currently in progress and is incomplete. Many features are not yet implemented and the ones that are may be unstable.

## How to Use

Currently, in this early stage, the program is ran with the Python3 interpreter.

```
python3 app.py
```

The program will attempt to retrieve the lastest card information from Scryfall every 24 hours and then listens on localhost:8080.

## Requirements

- Python3 which can be downloaded at [python.org](https://www.python.org/)
- The python requests module which can be installed with pip

```
pip install requets
```

## References

- All card data is gathered from the Scryfall api. Scryfall can be found at [scryfall.com](https://scryfall.com/)
- All artwork and information shown about the cards are copyright Wizards of the Coast, LLC
- The Bootstrap dark theme is sourced from [ForEvolve](https://github.com/ForEvolve/bootstrap-dark/)
