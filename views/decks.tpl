% rebase('base.tpl')
% import src.viewtilities as util
% from decimal import Decimal

<%
price_usd = Decimal('0.00')
price_tix = Decimal('0.00')
rarity = {'common': 0, 'uncommon': 0, 'rare': 0, 'mythic': 0, 'bonus': 0, 'special': 0}
curr_card = 0

if (model.commander is not None):
    price_usd += util.card_price(model.commander.card)
    price_tix += util.card_price_tix(model.commander.card)
    rarity[model.commander.card.rarity] += 1
end

if (model.partner is not None):
    price_usd += util.card_price(model.partner.card)
    price_tix += util.card_price_tix(model.partner.card)
    rarity[model.partner.card.rarity] += 1
end

if (model.companion is not None):
    price_usd += util.card_price(model.companion.card)
    price_tix += util.card_price_tix(model.companion.card)
    rarity[model.companion.card.rarity] += 1
end

for key in model.maindeck_cards:
    if (model.maindeck_cards[key]['card'] is not None):
        card = model.maindeck_cards[key]['card'].card
        quantity = model.maindeck_cards[key]['quantity']
        price_usd += quantity * util.card_price(card)
        price_tix += quantity * util.card_price_tix(card)
        rarity[card.rarity] += quantity
    end
end

for key in model.sideboard_cards:
    if (model.sideboard_cards[key]['card'] is not None):
        card = model.sideboard_cards[key]['card'].card
        quantity = model.sideboard_cards[key]['quantity']
        price_usd += quantity * util.card_price(card)
        price_tix += quantity * util.card_price_tix(card)
        rarity[card.rarity] += quantity
    end
end
%>
<div class="container">
    <div class="row">
        <div class="col-md-6">
            <div class="d-flex align-items-end mt-2">
                <h1 class="mr-4 my-0">{{model.deck.name}}</h1>
                <strong class="h3 my-0 pb-sm-1 text-capitalize">{{model.deck.format}}</strong>
            </div>
            <p class=" my-0">Created {{model.deck.created.strftime("%a %b %d, %Y %I:%M:%S %p")}}</p>
        </div>
        <div class="col-md-6">
            <div class="d-block clearfix">
                <div class="d-flex float-right align-items-end mt-2 ">
                    <p class="h2 text-success mr-4">${{price_usd}} USD</p>
                    <p class="h2 text-warning">{{price_tix}} TIX</p>
                </div>
            </div>
            <div class="float-right align-items-end mb-2">
                <p class="mb-0">{{rarity['common']}} Commons, {{rarity['uncommon']}} Uncommons, {{rarity['rare']}} Rares, {{rarity['mythic']}} Mythic</p>
            </div>
        </div>
    </div>
    <hr class="my-1"></hr>
    <div class="row">
        <div class="col-md-9">
            <div class="row">
                <div class="col-md-2 border-right pr-1 py-2">
                    <div class="w-100 mb-2"><div class="card-preview" style="height: 6rem;  background-image: url('/assets/img/card_back.jpg');" data-placement="top" data-toggle="tooltip" title="placeholder"></div></div>
                    <a class="btn btn-outline-primary text-left w-100 mr-sm-1 px-2 mb-1" href="/decks/edit/{{model.deck.id}}"><span class="far fa-edit mr-1"></span>Edit</a>
                    <a class="btn btn-outline-primary text-left w-100 mr-sm-1 px-2 mb-1" href="#"><span class="far fa-copy mr-1"></span>Edit Copy</a>
                    <a class="btn btn-outline-primary text-left w-100 mr-sm-1 px-2 mb-1" href="#"><span class="fas fa-download mr-1"></span>Download</a>
                    <a class="btn btn-outline-primary text-left w-100 mr-sm-1 px-2" href="#"><span class="fas fa-file-export mr-1"></span>Export</a>
                </div>
                <div class="col-md-10">
                    <ul class="nav nav-pills border-bottom justify-content-end py-2 mb-1" id="pills-tab" role="tablist">
                        <li class="nav-item" role="presentation">
                            <a class="nav-link active" id="pills-paper-tab" data-toggle="pill" href="#pills-paper" role="tab" aria-controls="pills-paper" aria-selected="true">Paper</a>
                        </li>
                        <li class="nav-item" role="presentation">
                            <a class="nav-link" id="pills-mtgo-tab" data-toggle="pill" href="#pills-mtgo" role="tab" aria-controls="pills-mtgo" aria-selected="false">MTGO</a>
                        </li>
                        <li class="nav-item" role="presentation">
                            <a class="nav-link" id="pills-rarity-tab" data-toggle="pill" href="#pills-rarity" role="tab" aria-controls="pills-rarity" aria-selected="false">Rarity</a>
                        </li>
                    </ul>
                    <div class="tab-content" id="pills-tabContent">
                        <div class="tab-pane show active" id="pills-paper" role="tabpanel" aria-labelledby="pills-paper-tab">
                            % include('partial/deck_table.tpl', tab = 'paper')
                        </div>
                        <div class="tab-pane" id="pills-mtgo" role="tabpanel" aria-labelledby="pills-mtgo-tab">
                            % include('partial/deck_table.tpl', tab = 'mtgo')
                        </div>
                        <div class="tab-pane" id="pills-rarity" role="tabpanel" aria-labelledby="pills-rarity-tab">
                            % include('partial/deck_table.tpl', tab = 'rarity')
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            % if len(model.missing_cards) > 0:
            <p class="h3 py-2 mb-0">Missing Cards</p>
            <hr class="mt-1"></hr>
                % for card_type in model.missing_cards:
                <p class="font-weight-bold mb-1">{{card_type}} ({{len(model.missing_cards[card_type])}})</p>
                    % for name in model.missing_cards[card_type]:
                        <p class="ml-2 mb-1 {{util.deck_card_text_color(model.missing_cards[card_type][name]['card'])}}">{{model.missing_cards[card_type][name]['quantity']}}x <a class="text-light" rel="popover" data-img="{{util.card_image(model.missing_cards[card_type][name]['card'].card, 'normal')}}" href="/cards/{{model.missing_cards[card_type][name]['card'].card.id}}">{{name}}</a></p>
                    % end
                % end
            % end
        </div>
    </div>
</div>
<script src="/assets/js/popover_preview.js" type="text/javascript" defer></script>