% rebase('base.tpl')
% import viewtilities as util
<div class="container">
    <div class="row mt-2">
        <div class="col-md d-flex">
            <img class="mr-2" style="max-width:3rem; max-height:3rem; filter: invert(60%)" src="{{model.selected_set.icon_svg_uri}}"></img>
            <div>
                <p class="h4 mb-0">{{model.selected_set.name}} <span class="text-muted text-uppercase">({{model.selected_set.code}})</span></p>
                <p class="mb-0 text-muted">Released {{model.selected_set.released}} • {{model.selected_set.card_count}} Cards • <span class="text-capitalize">{{util.clean_text(model.selected_set.set_type)}}</span></p>
            </div>
        </div>
        <form class="col-md form-inline justify-content-end" method="GET">
            <label class="mr-sm-2" for="order">Order By</label>
            <select class="custom-select mr-sm-2" name="order" id="order">
                <option {{util.selected(query.order, 'name')}} value="name">Name</option>
                <option {{util.selected(query.order, 'release')}} value="release">Release Date</option>
                <option {{util.selected(query.order, 'rarity')}} value="rarity">Rarity</option>
                <option {{util.selected(query.order, 'cmc')}} value="cmc">CMC</option>
                <option {{util.selected(query.order, 'color')}} value="color">Color</option>
                <option {{util.selected(query.order, 'power')}} value="power">Power</option>
                <option {{util.selected(query.order, 'toughness')}} value="toughness">Toughnes</option>
                <option {{util.selected(query.order, 'price')}} value="price">Price</option>
            </select>
            <label class="mr-sm-2" for="direction">|</label>
            <select class="custom-select mr-sm-3" name="direction" id="direction">
                <option {{util.selected(query.direction, 'asc')}} value="asc">Asc</option>
                <option {{util.selected(query.direction, 'desc')}} value="desc">Desc</option>
            </select>
            <button class="btn btn-outline-primary" type="submit">Apply</button>
        </form>
    </div>
    <hr class="my-2"></hr>
    <div class="d-flex flex-wrap justify-content-between">
        <% 
        carousel_count = 0
        if (query.get('order') is not None):
            r = False
            if (query.get('direction') == 'desc'):
                r = True
            end
            if (query.get('order') == 'name'):
                model.set_cards.sort(key=lambda x: x.name, reverse=r)
            elif (query.get('order') == 'release'):
                model.set_cards.sort(key=lambda x: x.released, reverse=r)
            elif (query.get('order') == 'rarity'):
                model.set_cards.sort(key=util.sort_by_rarity, reverse=r)
            elif (query.get('order') == 'cmc'):
                model.set_cards.sort(key=lambda x: x.cmc, reverse=r)
            elif (query.get('order') == 'color'):
                model.set_cards.sort(key=lambda x: x.color_identity, reverse=r)
            elif (query.get('order') == 'power'):
                model.set_cards.sort(key=util.sort_by_power, reverse=r)
            elif (query.get('order') == 'toughness'):
                model.set_cards.sort(key=util.sort_by_toughness, reverse=r)
            elif (query.get('order') == 'price'):
                model.set_cards.sort(key=util.sort_by_price, reverse=r)
            end
        end
        %>

        % for card in model.set_cards:
        <div class="grid-item my-1">
            % if (card.image_uris.get('normal') is not None):
            <a href="/cards/{{card.id}}"><img class="w-100 card-rounded" src="{{card.image_uris.get('normal')}}" alt="{{card.name}}"></a>
            % elif (card.faces is not None and len(card.faces) > 0):
                % include('multi_card_grid_image.tpl')
                % carousel_count += 1
            % else:
            <a href="/cards/{{card.id}}"><img class="w-100 card-rounded" src="/assets/img/card_back.jpg" alt="{{card.name}}"></a>
            % end
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