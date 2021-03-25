% rebase('base.tpl')
% import src.viewtilities as util
<div class="container">
    <h1 class="d-none">Deck Wolf</h1>
    <div class="mt-4">
        <div class="d-flex justify-content-center">
            <div class="position-relative" style="width: 14rem; height: 22rem;">
                % if model is None:
                <a class="position-absolute shadow" style="width: 14rem; left:-10rem;" href="/cards/"><img class="w-100 card-rounded" src="/assets/img/card_back.jpg"></a>
                <a class="position-absolute shadow" style="width: 14rem; left:10rem; top: 1rem;" href="/cards/"><img class="w-100 card-rounded" src="/assets/img/card_back.jpg"></a>
                <a class="position-absolute shadow" style="width: 14rem; top: 3rem" href="/cards/"><img class="w-100 card-rounded" src="/assets/img/card_back.jpg"></a>
                % else:
                <a class="position-absolute shadow" style="width: 14rem; left:-10rem;" href="/cards/{{model[0].id}}"><img class="w-100 card-rounded" src="{{util.card_image(model[0], 'normal')}}"></a>
                <a class="position-absolute shadow" style="width: 14rem; left:10rem; top: 1rem;" href="/cards/{{model[1].id}}"><img class="w-100 card-rounded" src="{{util.card_image(model[1], 'normal')}}"></a>
                <a class="position-absolute shadow" style="width: 14rem; top: 3rem" href="/cards/{{model[2].id}}"><img class="w-100 card-rounded" src="{{util.card_image(model[2], 'normal')}}"></a>
                % end
            </div>
        </div>
        <div class="position-relative">
            <h1 class="text-center mb-4"><img src="/assets/img/wolf-icon.svg" alt="Wolf icon" class="d-inline-block" style="width:4rem;height:4rem;filter:invert(85%)"/> Deck Wolf</h1>
            <form class="form-inline justify-content-center mx-auto mb-3" action="/search" method="get">
                <input class="form-control w-50 form-control-lg mr-sm-2" type="text" name="q" placeholder="Search" aria-label="Search">
                <button class="btn-lg btn btn-outline-success" type="submit">Search</button>
            </form>
        </div>
    </div>
</div>