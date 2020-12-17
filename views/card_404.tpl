% rebase('base.tpl')
<div class="container">
    <div class="mt-5">
        <h1 class="text-center">Oops...</h1>
        <p class="text-center h4 mb-5">We couldn't find what you were looking for.</p>
        <form class="form-inline justify-content-center mx-auto mb-3" action="/search" method="get">
            <input class="form-control w-50 form-control-lg mr-sm-2" type="text" name="q" placeholder="Search" aria-label="Search">
            <button class="btn-lg btn btn-outline-success" type="submit">Search</button>
        </form>
        <div class="d-flex justify-content-center">
            <a class="btn btn-outline-primary" href="/advanced-search/">Advanced Search</a>
        </div>
    </div>
</div>