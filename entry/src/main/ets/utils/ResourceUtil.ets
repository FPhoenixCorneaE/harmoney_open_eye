/**
 * 资源Resource类型转为string
 * @param resource
 * @returns
 */
export function resource2String(resource: Resource): string {
  return getContext(this).resourceManager.getStringSync(resource)
}