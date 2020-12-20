<nav class="navbar navbar-expand-lg navbar-dark border-bottom bg-dark">
        <div class="container">
        <a class="navbar-brand" href="/">Home</a>
        <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbar">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse " id="navbar">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item mx-1 align-items-center d-flex justify-content-center">
                    <a class="nav-link" href="/cards/">Cards</a>
                </li>
                <li class="nav-item mx-1 align-items-center d-flex justify-content-center">
                    <a class="nav-link" href="/sets/">Sets</a>
                </li>
                <li class="nav-item mx-1 align-items-center d-flex justify-content-center">
                    <a class="nav-link" href="/collection/">Collection</a>
                </li>
                <li class="nav-item dropdown mx-1 align-items-center d-flex justify-content-center">
                    <a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">Decks</a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="/decks/">My Decks</a>
                        <a class="dropdown-item" href="/decks/create">New Deck</a>
                    </div>
                </li>
            </ul>
            <ul class="navbar-nav flex-row justify-content-center mt-2 mt-md-0">
                <li class="nav-item">
                    <a class="nav-link" href="https://github.com/JohnPaquete/deck-maker" target="blank" data-placement="bottom" data-toggle="tooltip" title="View source">
                    <i class="fa fa-fw fa-2x fa-github-square"></i>
                    </a>
                </li>
            </ul>
            <form class="form-inline my-2 my-lg-0" action="/search" method="get">
                <input class="form-control mr-sm-2" type="text" name="q" placeholder="Search" aria-label="Search">
                <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
            </form>
        </div>
        </div>
    </nav>