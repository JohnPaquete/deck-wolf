% if len(category_cards) > 0:
<tr>
    <th colspan="4">{{category}} ({{sum(model.maindeck_cards[key]['quantity'] for key in category_cards)}})</th>
</tr>
% end
% for key in category_cards:
    % include('partial/deck_card_row.tpl', quantity = model.maindeck_cards[key]['quantity'], name = key, model = model.maindeck_cards[key]['card'])
    % count += 1
    % if count == int(model.card_count/2):
        % include('partial/deck_table_break.tpl')
    % end
% end