% import viewtilities as util
<tr>
    <td>{{quantity}}x</td>
    % if model is not None:
    <td><a class="text-light" href="/cards/{{model.card.id}}">{{name}}</a></td>
    <td>{{model.card.mana_cost}}</td>
    % if tab == 'paper':
    <td class="text-right text-success">{{util.card_cost(model.card, tab)}}</td>
    % elif tab == 'mtgo':
    <td class="text-right text-warning">{{util.card_cost(model.card, tab)}}</td>
    % elif tab == 'rarity':
    <td class="text-right text-capitalize">{{util.card_cost(model.card, tab)}}</td>
    % end
    % else:
    <td class="text-danger">{{name}}</td>
    <td>--</td>
    <td class="text-right">--</td>
    % end
</tr>