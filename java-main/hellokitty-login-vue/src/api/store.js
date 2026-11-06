// 收藏 & 购物车共享状态（localStorage 持久化 + 响应式，导航栏角标实时更新）
import { reactive } from 'vue'

function load(key) {
  try {
    return JSON.parse(localStorage.getItem(key) || '[]')
  } catch (e) {
    return []
  }
}

export const store = reactive({
  favorites: load('kitty_favorites'),
  cart: load('kitty_cart'),

  persist() {
    localStorage.setItem('kitty_favorites', JSON.stringify(this.favorites))
    localStorage.setItem('kitty_cart', JSON.stringify(this.cart))
  },

  isFavorite(id) {
    return this.favorites.some(i => String(i.id) === String(id))
  },

  toggleFavorite(item) {
    const idx = this.favorites.findIndex(i => String(i.id) === String(item.id))
    if (idx >= 0) {
      this.favorites.splice(idx, 1)
      this.persist()
      return false
    }
    this.favorites.unshift({ ...item })
    this.persist()
    return true
  },

  addToCart(item, qty = 1) {
    const exist = this.cart.find(i => String(i.id) === String(item.id))
    if (exist) {
      exist.qty += qty
    } else {
      this.cart.push({
        id: item.id,
        name: item.name,
        emoji: item.emoji,
        image: item.image,
        tag: item.tag,
        price: item.price,
        description: item.description,
        qty
      })
    }
    this.persist()
  },

  updateQty(id, qty) {
    const exist = this.cart.find(i => String(i.id) === String(id))
    if (!exist) return
    exist.qty = Math.max(1, qty)
    this.persist()
  },

  removeFromCart(id) {
    this.cart = this.cart.filter(i => String(i.id) !== String(id))
    this.persist()
  },

  clearCart() {
    this.cart = []
    this.persist()
  },

  cartCount() {
    return this.cart.reduce((s, i) => s + (i.qty || 1), 0)
  },

  cartTotal() {
    return this.cart.reduce((s, i) => s + Number(i.price) * (i.qty || 1), 0)
  }
})
