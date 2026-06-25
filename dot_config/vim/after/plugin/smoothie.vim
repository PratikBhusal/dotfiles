" This value controls linear term of the velocity curve. Increasing this boosts
" primarily cursor speed at the beginning of animation. As of writing this, the
"
" Default: 10
let g:smoothie_speed_linear_factor = 15

" This value controls exponent of the power function in the velocity curve.
" Generally should be less or equal to 1.0. Lower values produce longer but
" perceivably smoother animation.
"
" Default: 0.9
let g:smoothie_speed_exponentiation_factor = 1
