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
                % category_cards.sort(key=lambda x: util.sort_dict_by_cmc(x, model.maindeck_cards))
                % include('partial/deck_card_category.tpl', category='Creatures', count = curr_card)
                % curr_card += len(category_cards)

                % category_cards = [name for name, value in model.maindeck_cards.items() if value['type'] == 'Planeswalkers']
                % category_cards.sort(key=lambda x: util.sort_dict_by_cmc(x, model.maindeck_cards))
                % include('partial/deck_card_category.tpl', category='Planeswalkers', count = curr_card)
                % curr_card += len(category_cards)

                % category_cards = [name for name, value in model.maindeck_cards.items() if value['type'] == 'Sorceries']
                % category_cards.sort(key=lambda x: util.sort_dict_by_cmc(x, model.maindeck_cards))
                % include('partial/deck_card_category.tpl', category='Sorceries', count = curr_card)
                % curr_card += len(category_cards)

                % category_cards = [name for name, value in model.maindeck_cards.items() if value['type'] == 'Instants']
                % category_cards.sort(key=lambda x: util.sort_dict_by_cmc(x, model.maindeck_cards))
                % include('partial/deck_card_category.tpl', category='Instants', count = curr_card)
                % curr_card += len(category_cards)

                % category_cards = [name for name, value in model.maindeck_cards.items() if value['type'] == 'Artifacts']
                % category_cards.sort(key=lambda x: util.sort_dict_by_cmc(x, model.maindeck_cards))
                % include('partial/deck_card_category.tpl', category='Artifacts', count = curr_card)
                % curr_card += len(category_cards)

                % category_cards = [name for name, value in model.maindeck_cards.items() if value['type'] == 'Enchanments']
                % category_cards.sort(key=lambda x: util.sort_dict_by_cmc(x, model.maindeck_cards))
                % include('partial/deck_card_category.tpl', category='Enchanments', count = curr_card)
                % curr_card += len(category_cards)

                % category_cards = [name for name, value in model.maindeck_cards.items() if value['type'] == 'Lands']
                % category_cards.sort(key=lambda x: util.sort_dict_by_cmc(x, model.maindeck_cards))
                % include('partial/deck_card_category.tpl', category='Lands', count = curr_card)
                % curr_card += len(category_cards)

                % category_cards = [name for name, value in model.maindeck_cards.items() if value['type'] == 'Other']
                % category_cards.sort(key=lambda x: util.sort_dict_by_cmc(x, model.maindeck_cards))
                % include('partial/deck_card_category.tpl', category='Other', count = curr_card)
                % curr_card += len(category_cards)

                % if len(model.sideboard_cards) > 0:
                <tr>
                    <th colspan="4">Sideboard ({{sum(model.sideboard_cards[key]['quantity'] for key in model.sideboard_cards)}})</th>
                </tr>
                % end
                % category_cards = [name for name, value in model.sideboard_cards.items()]
                % category_cards.sort(key=lambda x: util.sort_dict_by_cmc(x, model.sideboard_cards))
                % for key in category_cards:
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