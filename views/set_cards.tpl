% rebase('base.tpl')
% import viewtilities as util
<div class="container">
    <div class="row mt-2">
        <div class="col-md d-flex">
            <img class="mr-2" style="max-width:3rem; max-height:3rem; filter: invert(60%)" src="{{model.selected_set.icon_svg_uri}}"></img>
            <div>
                <p class="h4 mb-0">{{model.selected_set.name}} ({{model.selected_set.code}})</p>
                <p class="mb-0">{{model.selected_set.card_count}} cards • Released {{model.selected_set.released}} • {{model.selected_set.set_type}}</p>
            </div>
        </div>
        <form class="col-md form-inline" method="GET">
            <button class="btn btn-outline-primary" type="submit">Apply</button>
        </form>
    </div>
    <hr class="my-2"></hr>
    <div class="d-flex flex-wrap justify-content-between">
        % for c in model.set_cards:
        <div class="grid-item my-1">
            <img class="w-100" src="{{c.image_uris.get('png')}}" alt="{{c.name}}">
        </div>
        % end
        <div class="grid-item my-1">
        </div>
        <div class="grid-item my-1">
        </div>
        <div class="grid-item my-1">
        </div>
    </div>
</div>