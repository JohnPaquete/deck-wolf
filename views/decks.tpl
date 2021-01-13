% rebase('base.tpl')
% import viewtilities as util
% from decimal import Decimal

<%
price_usd = Decimal('0.00')
price_tix = Decimal('0.00')
rarity = {'common': 0, 'uncommon': 0, 'rare': 0, 'mythic': 0}

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
                <div class="col-md-2 border-right">
                </div>
                <div class="col-md-10">
                </div>
            </div>
        </div>
        <div class="col-md-3">
        </div>
    </div>
</div>