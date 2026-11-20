/* ============================================================
 * 轻量视觉特效（无第三方依赖，纯 DOM + Web Animations）
 * - heartBurst(el)        爱心爆发粒子
 * - beatHeart(el)         爱心跳动一下
 * - flyToCart(source,item) 物品飞入购物车图标
 * 所有临时节点在动画结束后自动移除，不污染 DOM。
 * ============================================================ */

function centerOf(el) {
  const r = el.getBoundingClientRect()
  return { x: r.left + r.width / 2, y: r.top + r.height / 2 }
}

/** 爱心爆发：从按钮位置向外迸发若干小爱心 */
export function heartBurst(el) {
  if (!el || typeof document === 'undefined') return
  const { x, y } = centerOf(el)
  const layer = document.createElement('div')
  Object.assign(layer.style, {
    position: 'fixed',
    left: '0',
    top: '0',
    width: '0',
    height: '0',
    zIndex: '10000',
    pointerEvents: 'none',
    overflow: 'visible'
  })
  document.body.appendChild(layer)

  const count = 8
  const hearts = ['💗', '💖', '💕', '💘']
  for (let i = 0; i < count; i++) {
    const p = document.createElement('span')
    p.textContent = hearts[i % hearts.length]
    p.style.cssText = `position:absolute;left:${x}px;top:${y}px;font-size:${12 + Math.random() * 10}px;will-change:transform,opacity;`
    layer.appendChild(p)

    const angle = (Math.PI * 2 * i) / count + (Math.random() - 0.5) * 0.4
    const dist = 40 + Math.random() * 40
    const dx = Math.cos(angle) * dist
    const dy = Math.sin(angle) * dist - 20

    p.animate(
      [
        { transform: 'translate(-50%, -50%) scale(0.4)', opacity: 1 },
        { transform: `translate(calc(-50% + ${dx * 0.6}px), calc(-50% + ${dy}px)) scale(1.1)`, opacity: 1, offset: 0.55 },
        { transform: `translate(calc(-50% + ${dx}px), calc(-50% + ${dy + 46}px)) scale(0.6)`, opacity: 0 }
      ],
      { duration: 780 + Math.random() * 220, easing: 'cubic-bezier(.25,.8,.35,1)', fill: 'forwards' }
    )
  }
  setTimeout(() => layer.remove(), 1150)
}

/** 爱心跳动：给目标元素一个短促的放大回弹 */
export function beatHeart(el) {
  if (!el || typeof document === 'undefined' || !el.animate) return
  el.animate(
    [
      { transform: 'scale(1)' },
      { transform: 'scale(1.35)', offset: 0.35 },
      { transform: 'scale(0.9)', offset: 0.65 },
      { transform: 'scale(1)' }
    ],
    { duration: 460, easing: 'ease-in-out' }
  )
}

/** 物品飞入购物车：从源元素飞向 [data-cart-fly-target] */
export function flyToCart(source, item) {
  if (typeof document === 'undefined') return
  const target = document.querySelector('[data-cart-fly-target]')
  if (!source || !target) return

  const from = centerOf(source)
  const to = centerOf(target)

  const flyer = document.createElement('div')
  flyer.textContent = (item && (item.emoji || item.image)) || '🎀'
  const isImg = !!(item && item.image && !item.emoji)
  if (isImg) {
    flyer.textContent = ''
    flyer.style.backgroundImage = `url(${item.image})`
    flyer.style.backgroundSize = 'cover'
    flyer.style.backgroundPosition = 'center'
  }
  Object.assign(flyer.style, {
    position: 'fixed',
    left: `${from.x}px`,
    top: `${from.y}px`,
    width: '34px',
    height: '34px',
    marginLeft: '-17px',
    marginTop: '-17px',
    borderRadius: isImg ? '10px' : '50%',
    fontSize: '26px',
    lineHeight: '34px',
    textAlign: 'center',
    background: isImg ? undefined : 'rgba(255,255,255,0.9)',
    boxShadow: '0 6px 18px rgba(255,92,147,0.45)',
    zIndex: '10000',
    pointerEvents: 'none',
    willChange: 'transform, opacity'
  })
  document.body.appendChild(flyer)

  const dx = to.x - from.x
  const dy = to.y - from.y
  const arc = -Math.min(160, Math.abs(dx) * 0.35 + 70)

  const anim = flyer.animate(
    [
      { transform: 'translate(0, 0) scale(1)', opacity: 1, offset: 0 },
      { transform: `translate(${dx * 0.5}px, ${dy * 0.4 + arc}px) scale(1.25)`, opacity: 1, offset: 0.5 },
      { transform: `translate(${dx}px, ${dy}px) scale(0.35)`, opacity: 0.85, offset: 1 }
    ],
    { duration: 720, easing: 'cubic-bezier(.45,.05,.55,.95)', fill: 'forwards' }
  )

  anim.finished
    .catch(() => {})
    .finally(() => {
      flyer.remove()
      // 到达时让购物车图标轻微弹一下
      if (target.animate) {
        target.animate(
          [{ transform: 'scale(1)' }, { transform: 'scale(1.18)', offset: 0.5 }, { transform: 'scale(1)' }],
          { duration: 300, easing: 'ease-out' }
        )
      }
    })
}
