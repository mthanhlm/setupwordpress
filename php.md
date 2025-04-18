/**
 * Ẩn giá sản phẩm và thay đổi nút "Add to Cart" thành nút liên hệ
 * Có điều chỉnh vị trí tiêu đề và kích thước nút
 */
// Ẩn giá sản phẩm
add_filter('woocommerce_get_price_html', 'custom_hide_price_function', 10, 2);
function custom_hide_price_function($price, $product) {
    return '';
}
// Ẩn biểu mẫu thêm vào giỏ hàng
add_action('woocommerce_single_product_summary', 'remove_add_to_cart_button', 1);
function remove_add_to_cart_button() {
    remove_action('woocommerce_single_product_summary', 'woocommerce_template_single_add_to_cart', 30);
    add_action('woocommerce_single_product_summary', 'custom_contact_button', 30);
}
// Thêm nút liên hệ thay thế với kích thước lớn hơn
function custom_contact_button() {
    echo '<div style="margin-top: 20px;"><a href="' . site_url('/contact-us') . '" class="button alt" style="font-size: 16px; padding: 12px 25px; font-weight: bold; text-transform: uppercase;">Liên hệ chúng tôi</a></div>';
}
// Ẩn giá trên trang danh sách sản phẩm
add_action('woocommerce_after_shop_loop_item', 'remove_loop_add_to_cart', 1);
function remove_loop_add_to_cart() {
    remove_action('woocommerce_after_shop_loop_item', 'woocommerce_template_loop_add_to_cart', 10);
    add_action('woocommerce_after_shop_loop_item', 'custom_loop_contact_button', 10);
}
// Thêm nút liên hệ vào trang danh sách sản phẩm với kích thước lớn hơn
function custom_loop_contact_button() {
    global $product;
    echo '<a href="' . site_url('/contact-us') . '" class="button alt" style="font-size: 14px; padding: 10px 20px; font-weight: bold; display: block; margin-top: 10px; text-align: center;">Liên hệ chúng tôi</a>';
}
// Ẩn mục số lượng sản phẩm
add_filter('woocommerce_is_sold_individually', 'custom_remove_quantity_fields', 10, 2);
function custom_remove_quantity_fields($return, $product) {
    return true;
}
// Điều chỉnh vị trí tiêu đề sản phẩm và kích thước font
add_action('wp_head', 'custom_product_title_spacing');
function custom_product_title_spacing() {
    ?>
    <style>
        .product_title {
            margin-bottom: 50px !important; /* Tăng khoảng cách dưới tiêu đề */
            padding-bottom: 20px !important; /* Thêm padding phía dưới */
            position: relative;
            font-size: 32px !important; /* Tăng kích thước font */
            font-weight: 600 !important; /* Tăng độ đậm của font */
            line-height: 1.2 !important; /* Điều chỉnh chiều cao dòng */
        }
        
        /* Thêm 2 dòng trống bằng pseudo-element */
        .product_title:before {
            content: '\A\A'; /* \A là ký tự xuống dòng */
            white-space: pre; /* Giữ nguyên các ký tự xuống dòng */
            display: block;
            height: 1em; /* Chiều cao tương đương 2 dòng */
        }
  
 
    </style>
    <?php
}
