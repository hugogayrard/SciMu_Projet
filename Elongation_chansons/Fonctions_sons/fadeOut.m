function sFade = fadeOut(s, tDebOut, Fe)

    if nargin < 3
        Fe = 44100;
    end
    
    fade = ones(size(s));
    fade((tDebOut*Fe):end) = -1/(length(s)/Fe-tDebOut)*((tDebOut*Fe):length(s))/Fe + length(s)/Fe/(length(s)/Fe-tDebOut);
    
    sFade = s.*fade;
end