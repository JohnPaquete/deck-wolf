% rebase('base.tpl')
% import viewtilities as util
<div class="container">
    <div class="mt-3">
        <h2 class="align-middle">
            {{model.card.name}}
            <small class="text-muted ml-2">{{model.card_set.name}}<img class="ml-2 pb-2" style="width:3rem; filter: invert(40%)" src="{{model.card_set.icon_svg_uri}}"></img></small>
        </h2>
    </div>
    <div class="row my-4">
        <div class="col-lg-4">
            <img class="w-100" src="{{model.card.image_uris.get('png')}}" alt="{{model.card.name}}">
            % if (model.card.artist is not None):
            <p class="mt-1 font-italic">Illustrated by {{model.card.artist}}</p>
            % end
            <button type="button" class="mt-1 btn btn-outline-primary w-100">Add to Collection</button>
        </div>
        <div class="col-lg-4">
            <div class="card">
                <div class="card-header h3">
                    {{model.card.name}} {{model.card.mana_cost}}
                </div>
                <div class="card-body">
                    <p class="card-text font-weight-bold">{{model.card.type_line}}</p>
                    % text = model.card.oracle_text.split('\n')
                    % for line in text:
                        <p class="card-text">{{line}}</p>
                    % end
                    % if (model.card.flavor_text is not None):
                    <p class="card-text font-italic">{{model.card.flavor_text}}</p>
                    % end
                    <hr></hr>
                    % if (model.card.power is not None and model.card.toughness is not None):
                    <p class="card-text">{{model.card.power}}/{{model.card.toughness}}</p>
                    <hr></hr>
                    % end
                    % if (model.card.loyalty is not None):
                    <p class="card-text">Loyalty: {{model.card.loyaly}}</p>
                    <hr></hr>
                    % end
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="card">
                <div class="card-header">
                    <div class="d-flex">
                        <img class="mr-3" style="width:3rem; filter: invert(90%)" src="{{model.card_set.icon_svg_uri}}"></img>
                        <div>
                            <p class="mb-1 h5">{{model.card_set.name}} ({{model.card_set.code}})</p>
                            <p class="mb-0">#{{model.card.collector_number}}/{{model.card_set.card_count}} · {{util.rarity(model.card.rarity)}} · {{model.card.released}}</p>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    % if (len(model.card.legalities) > 0):
                    <div class="row justify-content-around">
                        <div class="col-lg mt-1 px-1 clearfix">
                            <small class="w-50 float-left text-center {{util.legality_bg(model.card.legalities.get('standard'))}} p-1 rounded">{{util.legality(model.card.legalities.get('standard'))}}</small>
                            <small class="w-50 p-1 float-left">Standard</small>
                        </div>
                        <div class="col-lg mt-1 px-1 clearfix">
                            <small class="w-50 float-left text-center {{util.legality_bg(model.card.legalities.get('brawl'))}} p-1 rounded">{{util.legality(model.card.legalities.get('brawl'))}}</small>
                            <small class="w-50 p-1 float-left">Brawl</small>
                        </div>
                    </div>
                    <div class="row justify-content-around">
                        <div class="col-lg mt-1 px-1 clearfix">
                            <small class="w-50 float-left text-center {{util.legality_bg(model.card.legalities.get('pioneer'))}} p-1 rounded">{{util.legality(model.card.legalities.get('pioneer'))}}</small>
                            <small class="w-50 p-1 float-left">Pioneer</small>
                        </div>
                        <div class="col-lg mt-1 px-1 clearfix">
                            <small class="w-50 float-left text-center {{util.legality_bg(model.card.legalities.get('historic'))}} p-1 rounded">{{util.legality(model.card.legalities.get('historic'))}}</small>
                            <small class="w-50 p-1 float-left">Historic</small>
                        </div>
                    </div>
                    <div class="row justify-content-around">
                        <div class="col-lg mt-1 px-1 clearfix">
                            <small class="w-50 float-left text-center {{util.legality_bg(model.card.legalities.get('modern'))}} p-1 rounded">{{util.legality(model.card.legalities.get('modern'))}}</small>
                            <small class="w-50 p-1 float-left">Modern</small>
                        </div>
                        <div class="col-lg mt-1 px-1 clearfix">
                            <small class="w-50 float-left text-center {{util.legality_bg(model.card.legalities.get('pauper'))}} p-1 rounded">{{util.legality(model.card.legalities.get('pauper'))}}</small>
                            <small class="w-50 p-1 float-left">Pauper</small>
                        </div>
                    </div>
                    <div class="row justify-content-around">
                        <div class="col-lg mt-1 px-1 clearfix">
                            <small class="w-50 float-left text-center {{util.legality_bg(model.card.legalities.get('legacy'))}} p-1 rounded">{{util.legality(model.card.legalities.get('legacy'))}}</small>
                            <small class="w-50 p-1 float-left">Legacy</small>
                        </div>
                        <div class="col-lg mt-1 px-1 clearfix">
                            <small class="w-50 float-left text-center {{util.legality_bg(model.card.legalities.get('penny'))}} p-1 rounded">{{util.legality(model.card.legalities.get('penny'))}}</small>
                            <small class="w-50 p-1 float-left">Penny</small>
                        </div>
                    </div>
                    <div class="row justify-content-around">
                        <div class="col-lg mt-1 px-1 clearfix">
                            <small class="w-50 float-left text-center {{util.legality_bg(model.card.legalities.get('vintage'))}} p-1 rounded">{{util.legality(model.card.legalities.get('vintage'))}}</small>
                            <small class="w-50 p-1 float-left">Vintage</small>
                        </div>
                        <div class="col-lg mt-1 px-1 clearfix">
                            <small class="w-50 float-left text-center {{util.legality_bg(model.card.legalities.get('commander'))}} p-1 rounded">{{util.legality(model.card.legalities.get('commander'))}}</small>
                            <small class="w-50 p-1 float-left">Commander</small>
                        </div>
                    </div>
                    <hr></hr>
                    % end
                    % if (model.card.prices is not None):
                    <div>
                        <table class="table table-sm table-striped">
                            <thead class="thead-dark">
                                <tr>
                                    <th class="rounded-left border-top-0"></th>
                                    <th class="border-top-0">USD</th>
                                    <th class="border-top-0">EUR</th>
                                    <th class="rounded-right border-top-0">TIX</th>
                                </tr>
                            </thead>
                                <tr>
                                    <th>Non-foil</th>
                                    <td class="text-success">{{util.usd(model.card.prices.get("usd"))}}</td>
                                    <td class="text-info">{{util.eur(model.card.prices.get("eur"))}}</td>
                                    <td class="text-warning">{{model.card.prices.get("tix")}}</td>
                                </tr>
                                <tr>
                                    <th>Foil</th>
                                    <td class="text-success">{{util.usd(model.card.prices.get("usd_foil"))}}</td>
                                    <td class="text-info">{{util.eur(model.card.prices.get("eur_foil"))}}</td>
                                    <td class="text-warning"></td>
                                </tr>
                            <tbody>

                            </tbody>
                        </table>
                    </div>
                    % end
                </div>
            </div>
        </div>
    </div>
    % if (model.rulings is not None and len(model.rulings) > 0):
    <hr></hr>
    <div>
        <h3 class="mb-2">Rulings for {{model.card.name}}</h3>
        % count = 0
        % for r in model.rulings:
            % if (count % 2 == 0):
            <div class="row mx-1">
            % end
                <blockquote class="blockquote col-md-6">
                    <div style="line-height: 1.25"><small class="mb-0" >{{r.comment}}</small></div>
                    <footer class="blockquote-footer">({{r.published_at}}) <cite title="Source Title">{{r.source}}</cite></footer>
                </blockquote>
            % if (count % 2 == 1):
            </div>
            % end
            % count += 1
        % end
        % if (count % 2 == 1):
            </div>
        % end
    </div>
    % end
</div>

