% rebase('base.tpl')
% import src.viewtilities as util
<div class="container">
    <div class="mt-5">
        <h1 class="text-center mb-5">{{util.random_tutor()}} Your Cards</h1>
        <form class="form-inline justify-content-center mx-auto mb-3" action="/search" method="get">
            <input class="form-control w-50 form-control-lg mr-sm-2" type="text" name="q" placeholder="Search" aria-label="Search">
            <button class="btn-lg btn btn-outline-success" type="submit">Search</button>
        </form>
        <div class="d-flex justify-content-center">
            <a class="btn btn-outline-primary mx-1" href="/advanced-search/">Advanced Search</a>
            <a class="btn btn-outline-primary mx-1" href="/cards/random/">Random Card</a>
            <a class="btn btn-outline-primary mx-1" href="/sets/">All Sets</a>
        </div>
    </div>
</div>