% rebase('base.tpl')
% import viewtilities as util
% from decimal import Decimal

<%
price_usd = Decimal('0.00')
price_tix = Decimal('0.00')
rarity = {'common': 0, 'uncommon': 0, 'rare': 0, 'mythic': 0}
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
                    <a class="btn btn-outline-primary text-left w-100 mr-sm-1 px-2 mb-1" href="/decks/edit/{{model.deck.id}}"><span class="far fa-edit mr-1"></span>Edit</a>
                    <a class="btn btn-outline-primary text-left w-100 mr-sm-1 px-2 mb-1" href="#"><span class="far fa-copy mr-1"></span>Edit Copy</a>
                    <a class="btn btn-outline-primary text-left w-100 mr-sm-1 px-2 mb-1" href="#"><span class="fas fa-download mr-1"></span>Download</a>
                    <a class="btn btn-outline-primary text-left w-100 mr-sm-1 px-2" href="#"><span class="fas fa-file-export mr-1"></span>Export</a>
                </div>
                <div class="col-md-10">
                    <div class="row">
                        <div class="col-md-6 px-1">
                            <table class="table table-sm table-borderless table-striped">
                                <tbody>
                                    % if model.deck.commander != '':
                                    <tr>
                                        <th colspan="4">Commander</th>
                                    </tr>
                                        % include('partial/deck_card_row.tpl', quantity = 1 , name = model.deck.commander, model = model.commander)
                                        % curr_card += 1
                                        % if curr_card == int(model.card_count/2):
                                            % include('partial/deck_table_break.tpl')
                                        % end
                                    % end
                                    % if model.deck.partner != '':
                                    <tr>
                                        <th colspan="4">Partner</th>
                                    </tr>
                                        % include('partial/deck_card_row.tpl', quantity = 1 , name = model.deck.partner, model = model.partner)
                                        % curr_card += 1
                                        % if curr_card == int(model.card_count/2):
                                            % include('partial/deck_table_break.tpl')
                                        % end
                                    % end
                                    % if model.deck.companion != '':
                                    <tr>
                                        <th colspan="4">Companion</th>
                                    </tr>
                                        % include('partial/deck_card_row.tpl', quantity = 1 , name = model.deck.companion, model = model.companion)
                                        % curr_card += 1
                                        % if curr_card == int(model.card_count/2):
                                            % include('partial/deck_table_break.tpl')
                                        % end
                                    % end
                                    
                                    % category_cards = [name for name, value in model.maindeck_cards.items() if value['type'] == 'Creatures']
                                    % include('partial/deck_card_category.tpl', category='Creatures', count = curr_card)
                                    % curr_card += len(category_cards)

                                    % category_cards = [name for name, value in model.maindeck_cards.items() if value['type'] == 'Planeswalkers']
                                    % include('partial/deck_card_category.tpl', category='Planeswalkers', count = curr_card)
                                    % curr_card += len(category_cards)

                                    % category_cards = [name for name, value in model.maindeck_cards.items() if value['type'] == 'Sorceries']
                                    % include('partial/deck_card_category.tpl', category='Sorceries', count = curr_card)
                                    % curr_card += len(category_cards)

                                    % category_cards = [name for name, value in model.maindeck_cards.items() if value['type'] == 'Instants']
                                    % include('partial/deck_card_category.tpl', category='Instants', count = curr_card)
                                    % curr_card += len(category_cards)

                                    % category_cards = [name for name, value in model.maindeck_cards.items() if value['type'] == 'Artifacts']
                                    % include('partial/deck_card_category.tpl', category='Artifacts', count = curr_card)
                                    % curr_card += len(category_cards)

                                    % category_cards = [name for name, value in model.maindeck_cards.items() if value['type'] == 'Enchanments']
                                    % include('partial/deck_card_category.tpl', category='Enchanments', count = curr_card)
                                    % curr_card += len(category_cards)

                                    % category_cards = [name for name, value in model.maindeck_cards.items() if value['type'] == 'Lands']
                                    % include('partial/deck_card_category.tpl', category='Lands', count = curr_card)
                                    % curr_card += len(category_cards)

                                    % category_cards = [name for name, value in model.maindeck_cards.items() if value['type'] == 'Other']
                                    % include('partial/deck_card_category.tpl', category='Other', count = curr_card)
                                    % curr_card += len(category_cards)

                                    % if len(model.sideboard_cards) > 0:
                                    <tr>
                                        <th colspan="4">Sideboard ({{sum(model.sideboard_cards[key]['quantity'] for key in model.sideboard_cards)}})</th>
                                    </tr>
                                    % end
                                    % for key in model.sideboard_cards:
                                        % include('partial/deck_card_row.tpl', quantity = model.sideboard_cards[key]['quantity'], name = key, model = model.sideboard_cards[key]['card'])
                                        % curr_card += 1
                                        % if curr_card == int(model.card_count/2):
                                            % include('partial/deck_table_break.tpl')
                                        % end
                                    % end
                                    <tr>
                                        <th colspan="4">Total Cards ({{model.card_total}})</th>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
        </div>
    </div>
</div>