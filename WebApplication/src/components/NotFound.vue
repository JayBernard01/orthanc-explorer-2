<script>
export default {
    props: [],
    data() {
        return {
            path: null
        };
    },
    mounted() {
        this.path = this.$router.currentRoute.value.fullPath;
    }
}

</script>
<template>
    <div class="alert alert-danger" role="alert">
        <h1>faisons un test ridicule pour voir si ca fonctionne!</h1>
        {{$t('page_not_found')}} <br/>
        {{path}}
    </div>
</template>
<style scoped>
</style>