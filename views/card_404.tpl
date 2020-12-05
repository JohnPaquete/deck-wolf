% rebase('base.tpl')
<div class="container">
    <div class="jumbotron mt-2">
        <h1 class="text-center">Oops...</h1>
        <p class="text-center">We couldn't find what you were looking for.</p>
        <form class="form-inline justify-content-center mx-auto my-2 my-lg-0" action="/search" method="get">
            <input class="form-control mr-sm-2" type="text" name="q" placeholder="Search" aria-label="Search">
            <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
        </form>
    </div>
</div>