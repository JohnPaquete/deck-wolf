% rebase('base.tpl')

<div class="container">
    <div class="py-2">
        <h1>About</h1>
        <div class='pl-3'>
            <p>Deck Wolf lets you search through the entire Magic: The Gathering card collection since its inception. Deck Wolf is currently incomplete and some features may only be partially implemented and tested. The main features that have been partially or fully implemented are the card search, card collection, card binder, and deck maker tools.</p>
            <h2>Search</h2>
            <div class='pl-3'>
                <p>The general search function allows you to search cards by name and will return a list of the most recent version of match cards. A more refined advanced search is available to filter results by a more comprehensive suite of card attributes. A link to the advanced search page can be found <a class="text-primary" href="/advanced-search/">here</a>.</p>
            </div>
            <h2>Collection</h2>
            <div class='pl-3'>
                <p>The collection is a way to keep track of each Magic card you own. On every card page there is a field that allows you to submit how many copies of a card you have. This will add it to your collection which can be viewed <a class="text-primary" href="/collection/">here</a>. Your collection is used to determine what cards you are missing from both your decks and binders.</p>
                <h3>Binders</h3>
                <div class='pl-3'>
                    <p>A binder can be thought of as a wishlist. It is a set of Magic cards that you want to complete. You can create a binder <a class="text-primary" href="/collection/binders/">here</a>. Like the collection, you can add a card to an existing binder on each card's page. A binder can be either specific or general. A general binder will consider any printing of a card when checking if it is complete while a specific binder will require the exact printing.</p>
                </div>
            </div>
            <h2>Decks</h2>
            <div class='pl-3'>
                <p>The deck making tool allows you to create decks in a number of formats. Card names are entered manually but there is an autcomplete feature on the input fields to speed up the process. You can create a deck <a class="text-primary" href="/decks/">here</a>. If a card is not found in the database, it will be highlighted in red. The sidebar contains a list of cards that are missing from your collection if you want to complete the deck.</p>
            </div>
            <h2>Attribution</h2>
            <div>
                <ul>
                    <li>All card data is gathered from the Scryfall API. Scryfall can be found at <a class="text-primary" href="https://scryfall.com/">scryfall.com</a>.</li>
                    <li>All artwork and information shown about the cards are copyright Wizards of the Coast, LLC.</li>
                    <li>Bootstrap dark theme is sourced from <a class="text-primary" href="https://github.com/ForEvolve/bootstrap-dark/">ForEvolve on GitHub</a>.</li>
                    <li>Magic: the Gathering mana symbol font is sourced from <a class="text-primary" href="https://github.com/andrewgioia/mana">Andrew Gioia on GitHub</a>.</li>
                </ul>
            </div>
        </div>
    </div>
</div>