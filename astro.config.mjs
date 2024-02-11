import { defineConfig } from 'astro/config';
import mdx from '@astrojs/mdx';
import icon from "astro-icon";
import sitemap from '@astrojs/sitemap';

// https://astro.build/config
export default defineConfig({
	site: 'https://lysdestic.com',
	integrations: [mdx(), sitemap(), icon()],
});