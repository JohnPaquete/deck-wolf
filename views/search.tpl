% rebase('base.tpl')
% import viewtilities as util

<div class="container">
    <hr class="my-2"></hr>
    <div class="d-flex flex-wrap justify-content-between">
        % carousel_count = 0
        % for card in model:
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