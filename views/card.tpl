% rebase('base.tpl')
% import src.viewtilities as util
% import math
<div class="container">
    <div class="mt-3">
        <h1 class="align-middle">
            {{model.card.name}}
            <small class="text-muted ml-2">{{model.card_set.name}}<img class="ml-2 pb-2" style="width:3rem; filter: invert(40%)" src="{{model.card_set.icon_svg_uri}}"></img></small>
        </h1>
    </div>
    <div class="row my-4">
        <div class="col-lg-4 mb-2">
            % if (model.card.image_uris.get('png') is not None):
            <img class="w-100" src="{{model.card.image_uris.get('png')}}" alt="{{model.card.name}}">
            % elif (model.card.faces is not None and len(model.card.faces) > 0):
            % include('partial/multi_card_image.tpl')
            % else:
            <img class="w-100" src="/assets/img/card_back.jpg" alt="{{model.card.name}}">
            % end
            % if (model.card.artist is not None):
            <p class="mt-1 font-italic">Illustrated by {{model.card.artist}}</p>
            % end
            <button type="button" class="mt-1 btn btn-outline-primary btn-block" data-toggle="collapse" data-target="#collection_form" aria-expanded="false" aria-controls="collection_form"><i class="fas fa-archive mr-2"></i>Add to Collection</button>
            <div class="collapse" id="collection_form">
                <form class="mt-2" action="/cards/{{model.card.id}}" method="POST">
                    <div class="input-group">
                        <input type="hidden" name="method" value="POST">
                        <input type="hidden" name="route" value="COLLECTION">
                        <input type="number" class="form-control rounded-right mr-1" name="quantity" id="quantity" aria-describedby="quantity" value="{{model.collection.quantity}}" min="0">
                        <button class="btn btn-outline-primary" type="submit">Apply</button>
                    </div>
                </form>
            </div>
            % if len(binders) > 0:
            <button type="button" class="mt-1 btn btn-outline-primary btn-block" data-toggle="collapse" data-target="#binder_form" aria-expanded="false" aria-controls="binder_form"><i class="fas fa-book-open mr-2"></i>Add to Binder</button>
            <div class="collapse" id="binder_form">
                <form class="mt-2" action="/cards/{{model.card.id}}" method="POST">
                    <input type="hidden" name="method" value="POST">
                    <input type="hidden" name="route" value="BINDERCARD">
                    <input type="hidden" name="card_id" value="{{model.card.id}}">
                    <div class="input-group mb-2">
                        <select class="custom-select" name="binder_id" id="binder-id" required>
                            <option value="" selected disabled hidden>Select Binder</option>
                            % for b in binders:
                            <option value="{{b.id}}">{{b.name}}</option>
                            % end
                        </select>
                    </div>
                    <div class="input-group">
                        <input type="number" class="form-control rounded-right mr-1" name="quantity" id="binder-quantity" aria-describedby="binder-quantity" value="1" min="1">
                        <button class="btn btn-outline-primary" type="submit">Apply</button>
                    </div>
                </form>
            </div>
            % end
        </div>
        <div class="col-lg-4 mb-2">
            % if (model.card.faces is not None and len(model.card.faces) > 0):
            % include('partial/multi_card_info.tpl')
            % else:
            <div class="card">
                <div class="card-header h3">
                    {{model.card.name}} {{!util.insert_symbols(model.card.mana_cost, 'ms-sm')}}
                </div>
                <div class="card-body">
                    % if (model.card.oracle_text is not None):
                    <p class="card-text font-weight-bold">{{model.card.type_line}}</p>
                    % text = model.card.oracle_text.split('\n')
                    % count = 1
                    % for line in text:
                        % if (count == len(text)):
                        <p class="card-text">{{!util.insert_symbols(line, 'ms-sm')}}</p>
                        % else:
                        <p class="card-text mb-1">{{!util.insert_symbols(line, 'ms-sm')}}</p>
                        % end
                        % count += 1
                    % end
                    % end
                    % if (model.card.flavor_text is not None):
                    <p class="card-text font-italic">{{!util.insert_symbols(model.card.flavor_text, 'ms-sm')}}</p>
                    % end
                    <hr></hr>
                    % if (model.card.power is not None and model.card.toughness is not None):
                    <p class="card-text">{{model.card.power}}/{{model.card.toughness}}</p>
                    <hr></hr>
                    % end
                    % if (model.card.loyalty is not None):
                    <p class="card-text">Loyalty: {{model.card.loyalty}}</p>
                    <hr></hr>
                    % end
                </div>
            </div>
            % end
        </div>
        <div class="col-lg-4 mb-2">
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
                        <table class="table table-sm table-striped mb-0">
                            <thead class="thead-dark">
                                <tr>
                                    <th class="rounded-left border-top-0"></th>
                                    <th class="border-top-0">USD</th>
                                    <th class="border-top-0">EUR</th>
                                    <th class="rounded-right border-top-0">TIX</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <th>Non-foil</th>
                                    <td class="text-success">{{util.currency(model.card.prices.get("usd"), '$')}}</td>
                                    <td class="text-info">{{util.currency(model.card.prices.get("eur"), '€')}}</td>
                                    <td class="text-warning">{{util.currency(model.card.prices.get("tix"), '')}}</td>
                                </tr>
                                <tr>
                                    <th>Foil</th>
                                    <td class="text-success">{{util.currency(model.card.prices.get("usd_foil"), '$')}}</td>
                                    <td class="text-info">{{util.currency(model.card.prices.get("eur_foil"), '€')}}</td>
                                    <td class="text-warning">{{util.currency(None, '')}}</td>
                                </tr>
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
        <h2 class="mb-3">Rulings for {{model.card.name}}</h2>
        <div class="row mx-1">
        % count = 0
        % for r in model.rulings:
            % if (count == 0 or count == math.ceil(len(model.rulings) / 2)):
            <div class="col-md-6">
            % end
                <blockquote class="blockquote">
                    <div style="line-height: 1.25"><small class="mb-0" >{{!util.insert_symbols(r.comment, 'ms-sm')}}</small></div>
                    <footer class="blockquote-footer">({{r.published_at}}) <cite title="Source Title">{{r.source}}</cite></footer>
                </blockquote>
            % count += 1
            % if (count == len(model.rulings) or count == math.ceil(len(model.rulings) / 2)):
            </div>
            % end
        % end
        </div>
    </div>
    % end
</div>


