% import viewtilities as util
<tr>
    <td>{{quantity}}x</td>
    % if model is not None:
    <td><a class="text-light" href="/cards/{{model.card.id}}">{{name}}</a></td>
    <td>{{model.card.mana_cost}}</td>
    <td class="text-right">${{util.card_price(model.card)}}</td>
    % else:
    <td class="text-danger">{{name}}</td>
    <td>--</td>
    <td class="text-right">--</td>
    % end
</tr>