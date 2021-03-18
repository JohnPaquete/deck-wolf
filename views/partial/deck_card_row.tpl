% import src.viewtilities as util
<tr>
    <td>{{quantity}}x</td>
    % if model is not None:
    <td><a class="text-light" rel="popover" data-img="{{util.card_image(model.card, 'normal')}}" href="/cards/{{model.card.id}}">{{name}}</a></td>
    <td>{{model.card.mana_cost}}</td>
    % if tab == 'paper':
    <td class="text-right text-success">{{util.card_cost(model.card, tab)}}</td>
    % elif tab == 'mtgo':
    <td class="text-right text-warning">{{util.card_cost(model.card, tab)}}</td>
    % elif tab == 'rarity':
        % if model.card.rarity == 'common':
    <td class="text-right text-common">C</td>
        % elif model.card.rarity == 'uncommon':
    <td class="text-right text-uncommon">U</td>
        % elif model.card.rarity == 'rare':
    <td class="text-right text-rare">R</td>
        % elif model.card.rarity == 'mythic':
    <td class="text-right text-mythic">M</td>
        % else:
    <td class="text-right">--</td>
        % end
    % end
    % else:
    <td class="text-danger">{{name}}</td>
    <td>--</td>
    <td class="text-right">--</td>
    % end
</tr>