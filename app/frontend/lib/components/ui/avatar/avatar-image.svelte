<script lang="ts">
	import { cn } from "@/lib/utils"
	import { Avatar as AvatarPrimitive } from "bits-ui"

	let {
		class: className,
		src,
		alt,
		ref = $bindable(null),
		...restProps
	}: AvatarPrimitive.ImageProps = $props();
</script>

<AvatarPrimitive.Image
	bind:ref
	{src}
	{alt}
	class={cn("aspect-square size-full", className)}
	{...restProps}
/>
