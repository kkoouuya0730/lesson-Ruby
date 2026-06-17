# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

products = [
  {
    name: "Trail Running Shoes",
    description: "Lightweight trail shoes with strong grip for mixed terrain.",
    price: 12800,
    original_price: 15800,
    images: [
      "https://images.example.com/products/trail-shoes-1.jpg",
      "https://images.example.com/products/trail-shoes-2.jpg"
    ],
    category: "sports",
    stock: 42,
    rating: 4.6,
    review_count: 118,
    featured: true,
    tags: [ "running", "outdoor", "shoes" ]
  },
  {
    name: "Ceramic Coffee Dripper",
    description: "Stable ceramic dripper for clean, balanced pour-over coffee.",
    price: 3200,
    original_price: nil,
    images: [
      "https://images.example.com/products/dripper-1.jpg"
    ],
    category: "kitchen",
    stock: 80,
    rating: 4.4,
    review_count: 57,
    featured: false,
    tags: [ "coffee", "brew", "home" ]
  },
  {
    name: "Noise Canceling Headphones",
    description: "Over-ear wireless headphones with active noise cancellation.",
    price: 24800,
    original_price: 29800,
    images: [
      "https://images.example.com/products/headphones-1.jpg",
      "https://images.example.com/products/headphones-2.jpg"
    ],
    category: "electronics",
    stock: 25,
    rating: 4.7,
    review_count: 203,
    featured: true,
    tags: [ "audio", "wireless", "music" ]
  },
  {
    name: "Compact Desk Lamp",
    description: "Minimal LED desk lamp with adjustable brightness.",
    price: 5400,
    original_price: 6800,
    images: [
      "https://images.example.com/products/lamp-1.jpg"
    ],
    category: "interior",
    stock: 61,
    rating: 4.3,
    review_count: 34,
    featured: false,
    tags: [ "desk", "light", "minimal" ]
  },
  {
    name: "Organic Cotton T-Shirt",
    description: "Soft organic cotton T-shirt designed for daily wear.",
    price: 2900,
    original_price: nil,
    images: [
      "https://images.example.com/products/tshirt-1.jpg"
    ],
    category: "fashion",
    stock: 140,
    rating: 4.2,
    review_count: 76,
    featured: false,
    tags: [ "cotton", "casual", "daily" ]
  }
]

products.each do |attrs|
  product = Product.find_or_initialize_by(name: attrs[:name])
  product.assign_attributes(attrs)
  product.save!
end

puts "Seeded #{products.size} products"
