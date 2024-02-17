package madolib;

import madolib.event.Signal;

@:structInit
class Paginate<T> {
    public var onChangeItems = new Signal<Array<T>>();

    public var items(default, set): Array<T> = [];

    inline function set_items(v: Array<T>): Array<T> {
        items = v;
        onChangeItems(v);
        refresh();
        return v;
    }

    public var onePageItemCount(default, set): Int = 0;

    inline function set_onePageItemCount(v: Int): Int {
        onePageItemCount = v;
        refresh();
        return onePageItemCount;
    }

    public var currentPageItems(default, null): Array<T> = [];

    public var page(default, set): Int = 0;

    inline function set_page(v: Int): Int {
        page = if(pageLoop) Math.posMod(v, maxPage + 1) else Math.clamp(v, 0, maxPage);
        refresh();
        return page;
    }

    public var maxPage(default, null) = 0;

    public var pageLoop(default, default) = true;

    public function new(items: Array<T>, onePageItemCount: Int = 10) {
        this.items = items;
        this.onePageItemCount = onePageItemCount;
        refresh();
    }

    inline function refresh() {
        currentPageItems = getPageItems(page);
        maxPage = if(onePageItemCount == 0) 0 else Math.max(0, Math.floor((items.length - 1) / onePageItemCount));
    }

    public inline function nextPage() {
        page = page + 1;
    }

    public inline function prevPage() {
        page = page - 1;
    }

    public inline function getPageItems(p: Int): Array<T> {
        final start = onePageItemCount * page;
        return items.slice(start, start + onePageItemCount);
    }

    public inline function calcInPageIndex(index: Int): Int
        return index % onePageItemCount + page * onePageItemCount;

    public inline function getItemInPage(index: Int): Option<T> {
        final item = currentPageItems[index];
        return if(item != null) Some(item) else None;
    }
}
