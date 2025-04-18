/**
 * Remove default sidebar and add custom shop sidebar
 */
remove_action( 'woocommerce_sidebar', 'woocommerce_get_sidebar', 10 );
add_action( 'woocommerce_sidebar', 'woocommerce_get_sidebar_bingo', 11 );
function woocommerce_get_sidebar_bingo() {
	if( is_shop() || is_product_category() ){
		echo '<div id="sidebar" role="complementary">';
		dynamic_sidebar( 'shop' );
		echo '</div>';
	}
}

add_filter( 'woocommerce_add_to_cart_fragments', 'wc_refresh_mini_cart_count');
function wc_refresh_mini_cart_count($fragments){
    ob_start();
    $items_count = WC()->cart->get_cart_contents_count();
    ?>
    <div id="mini-cart-count"><?php echo esc_html( $items_count ) ? esc_html( $items_count ) :0; ?></div>
	<?php if( $items_count > 0 ){ ?>
		<script>
			if (jQuery('.add_to_cart_button.ajax_add_to_cart').hasClass('added')){
				jQuery( ".yith-wcqv-head a.yith-wcqv-close" ).trigger( "click" );
				jQuery( ".mini-cart a.dropdown-back" ).trigger( "click" );
			}
		</script>
    <?php
		}
        $fragments['#mini-cart-count'] = ob_get_clean();
    return $fragments;
}
