% count = 1
% for face in model.card.faces:
    % if (count < len(model.card.faces)):
    <div class="card mb-2">
    % else:
    <div class="card">
    % end
        <div class="card-header h3">
            {{face.get('name')}} {{face.get('mana_cost')}}
        </div>
        <div class="card-body">
            % if (face.get('oracle_text') is not None):
            <p class="card-text font-weight-bold">{{face.get('type_line')}}</p>
            % text = face.get('oracle_text').split('\n')
            % count = 1
            % for line in text:
                % if (count == len(text)):
                <p class="card-text">{{line}}</p>
                % else:
                <p class="card-text mb-1">{{line}}</p>
                % end
                % count += 1
            % end
            % end
            % if (face.get('flavor_text') is not None):
            <p class="card-text font-italic">{{face.get('flavor_text')}}</p>
            % end
            <hr></hr>
            % if (face.get('power') is not None and face.get('toughness') is not None):
            <p class="card-text">{{face.get('power')}}/{{face.get('toughness')}}</p>
            <hr></hr>
            % end
            % if (face.get('loyalty') is not None):
            <p class="card-text">Loyalty: {{face.get('loyaly')}}</p>
            <hr></hr>
            % end
        </div>
    </div>
    % count += 1
% end