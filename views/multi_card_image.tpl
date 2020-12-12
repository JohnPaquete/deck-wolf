
<div id="card_carousel" class="carousel slide" data-interval="false">
    <div class="carousel-inner">
        % count = 0
        % for face in model.card.faces:
            % if (count == 0):
        <div class="carousel-item active">
            % else:
        <div class="carousel-item">
            % end
            <img class="d-block w-100" src="{{face.get('image_uris').get('png')}}" alt="{{face.get('name')}}">
        </div>
        % count += 1
        % end
    </div>
    <a class="carousel-control-prev" href="#card_carousel" role="button" data-slide="prev">
        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        <span class="sr-only">Previous</span>
    </a>
    <a class="carousel-control-next" href="#card_carousel" role="button" data-slide="next">
        <span class="carousel-control-next-icon" aria-hidden="true"></span>
        <span class="sr-only">Next</span>
    </a>
</div>